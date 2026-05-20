import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import '../models/models.dart';
import '../database/database_helper.dart';

class AppProvider with ChangeNotifier {
  List<Group> _groups = [];
  int? _currentGroupId;
  List<Member> _currentMembers = [];
  List<Payment> _currentPayments = [];
  List<Debt> _currentDebts = [];

  final dbHelper = DatabaseHelper.instance;

  List<Group> get groups => _groups;
  Group? get currentGroup => _groups.where((g) => g.id == _currentGroupId).firstOrNull;
  List<Member> get currentMembers => _currentMembers;
  List<Payment> get currentPayments => _currentPayments;
  List<Debt> get currentDebts => _currentDebts;

  Future<void> loadData() async {
    _groups = await dbHelper.getGroups();
    if (_groups.isNotEmpty && _currentGroupId == null) {
      _currentGroupId = _groups.first.id;
    }
    if (_currentGroupId != null) {
      await loadGroupData(_currentGroupId!);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadGroupData(int groupId) async {
    _currentGroupId = groupId;
    _currentMembers = await dbHelper.getMembers(groupId);
    _currentPayments = await dbHelper.getPayments(groupId);
    _currentDebts = await dbHelper.getDebts(groupId);

    final group = currentGroup;
    if (group != null &&
        _currentMembers.isNotEmpty &&
        (group.turnIndex < 0 || group.turnIndex >= _currentMembers.length)) {
      final normalizedGroup = group.copyWith(turnIndex: 0);
      await dbHelper.updateGroup(normalizedGroup);
      _groups = await dbHelper.getGroups();
    }

    await updateHomeWidget();
    notifyListeners();
  }

  void setCurrentGroup(int groupId) {
    loadGroupData(groupId);
  }

  Future<void> addGroup(String name, double amount) async {
    final group = Group(name: name, amount: amount);
    final id = await dbHelper.insertGroup(group);
    await loadData();
    if (_groups.length == 1) {
      setCurrentGroup(id);
    }
  }

  Future<void> updateGroup(Group group) async {
    await dbHelper.updateGroup(group);
    await loadData();
  }

  Future<void> deleteGroup(int id) async {
    await dbHelper.deleteGroup(id);
    _currentGroupId = null;
    await loadData();
  }

  Future<void> addMember(String name) async {
    if (currentGroup == null) return;

    final orderIndex = _currentMembers.length;
    final member = Member(
      groupId: currentGroup!.id!,
      name: name,
      orderIndex: orderIndex,
    );

    await dbHelper.insertMember(member);
    await loadGroupData(currentGroup!.id!);
  }

  Future<void> deleteMember(int id) async {
    if (currentGroup == null) return;
    await dbHelper.deleteMember(id);
    if (_currentMembers.length > 1 && currentGroup!.turnIndex >= _currentMembers.length - 1) {
      final updatedGroup = Group(
        id: currentGroup!.id,
        name: currentGroup!.name,
        amount: currentGroup!.amount,
        turnIndex: 0,
      );
      await dbHelper.updateGroup(updatedGroup);
    }
    await loadData();
  }

  // Returns the true member who needs to pay this turn.
  // Normally it is the person at turnIndex.
  // But if the person at turnIndex is a CREDITOR (they paid on behalf of someone else),
  // then the DEBTOR is the one who actually owes the turn now.
  Member? get currentTurnMember {
    if (_currentMembers.isEmpty || currentGroup == null) return null;
    final turnIndex = currentGroup!.turnIndex;
    if (turnIndex < 0 || turnIndex >= _currentMembers.length) {
      return _currentMembers.first;
    }

    Member normalTurnMember = _currentMembers[turnIndex];

    // Check if this person is owed a turn (they are the creditor)
    final debt = _getDebtWhereCreditor(normalTurnMember.id!);
    if (debt != null) {
      // The person who actually needs to pay is the debtor
      try {
        return _currentMembers.firstWhere((m) => m.id == debt.debtorId);
      } catch (e) {
        return normalTurnMember;
      }
    }

    return normalTurnMember;
  }

  Debt? _getDebtWhereCreditor(int memberId) {
    try {
      return _currentDebts.firstWhere((d) => d.creditorId == memberId);
    } catch (e) {
      return null;
    }
  }

  Debt? getCurrentTurnDebt() {
    if (_currentMembers.isEmpty || currentGroup == null) return null;
    final turnIndex = currentGroup!.turnIndex;
    if (turnIndex < 0 || turnIndex >= _currentMembers.length) return null;
    Member normalTurnMember = _currentMembers[turnIndex];
    return _getDebtWhereCreditor(normalTurnMember.id!);
  }

  Future<void> markPaid() async {
    if (currentGroup == null || _currentMembers.isEmpty) return;

    final actualPayer = currentTurnMember!;

    // The person whose original index it was
    Member normalTurnMember = _currentMembers[currentGroup!.turnIndex];
    final debt = _getDebtWhereCreditor(normalTurnMember.id!);

    final payment = Payment(
      groupId: currentGroup!.id!,
      memberId: actualPayer.id!,
      amount: currentGroup!.amount,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await dbHelper.insertPayment(payment);

    if (debt != null) {
      // Clear the debt since the debtor finally paid for the creditor's turn
      await dbHelper.deleteDebt(debt.id!);
    }

    // Always advance the global turn index
    final nextIndex = (currentGroup!.turnIndex + 1) % _currentMembers.length;
    final updatedGroup = Group(
      id: currentGroup!.id,
      name: currentGroup!.name,
      amount: currentGroup!.amount,
      turnIndex: nextIndex,
    );

    await dbHelper.updateGroup(updatedGroup);
    await loadData();
  }

  // Paying on behalf
  // Let's say order is A -> B -> C -> D. Turn is on B (index 1).
  // B is unavailable, C pays.
  // Payer = C. TurnIndex = 1 (B's turn).
  // We record payment for C.
  // We record Debt: Debtor = B, Creditor = C.
  // We advance TurnIndex to C's slot (index 2).
  // When turnIndex becomes 2, the app will see that normalTurnMember is C.
  // It will check if C is a Creditor. Yes, C is creditor for B.
  // So currentTurnMember will return B. B will be prompted to pay.
  // After B pays, we clear the debt, and advance TurnIndex to 3 (D's slot).
  Future<void> markPaidOnBehalf(Member payerMember) async {
    if (currentGroup == null || _currentMembers.isEmpty) return;

    final normalTurnMember = _currentMembers[currentGroup!.turnIndex];

    if (payerMember.id == normalTurnMember.id) {
       await markPaid();
       return;
    }

    final payment = Payment(
      groupId: currentGroup!.id!,
      memberId: payerMember.id!,
      amount: currentGroup!.amount,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      paidForMemberId: normalTurnMember.id,
    );

    await dbHelper.insertPayment(payment);

    // Record debt: normalTurnMember (who missed their turn) owes payerMember
    final debt = Debt(
      groupId: currentGroup!.id!,
      debtorId: normalTurnMember.id!,
      creditorId: payerMember.id!,
    );
    await dbHelper.insertDebt(debt);

    int payerIndex = _currentMembers.indexOf(payerMember);
    if (payerIndex == -1) payerIndex = (currentGroup!.turnIndex + 1) % _currentMembers.length;

    final updatedGroup = Group(
      id: currentGroup!.id,
      name: currentGroup!.name,
      amount: currentGroup!.amount,
      turnIndex: payerIndex,
    );

    await dbHelper.updateGroup(updatedGroup);
    await loadData();
  }

  Future<void> nextGroup() async {
    if (_groups.isEmpty) return;
    if (_currentGroupId == null) {
      await loadGroupData(_groups.first.id!);
      return;
    }

    int currentIndex = _groups.indexWhere((g) => g.id == _currentGroupId);
    if (currentIndex != -1) {
      int nextIndex = (currentIndex + 1) % _groups.length;
      await loadGroupData(_groups[nextIndex].id!);
    }
  }

  Future<void> updateHomeWidget() async {
    if (currentGroup == null || _currentMembers.isEmpty) return;

    final turnMember = currentTurnMember;
    String turnText = turnMember?.name ?? "No members";
    String infoText = "Tap to mark paid";

    final debt = getCurrentTurnDebt();
    if (debt != null) {
       final creditor = _currentMembers.firstWhere((m) => m.id == debt.creditorId, orElse: () => Member(groupId: 0, name: 'Someone', orderIndex: -1));
       infoText = "Pay for ${creditor.name} (Swap)";
    }

    await HomeWidget.saveWidgetData('group_name', currentGroup!.name);
    await HomeWidget.saveWidgetData('turn_member', turnText);
    await HomeWidget.saveWidgetData('info_text', infoText);
    await HomeWidget.updateWidget(
      androidName: 'WaterTrackerWidget',
    );
  }
}
