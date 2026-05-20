class Group {
  final int? id;
  final String name;
  final double amount;
  final int turnIndex;

  Group({
    this.id,
    required this.name,
    required this.amount,
    this.turnIndex = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'turnIndex': turnIndex,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      turnIndex: map['turnIndex'],
    );
  }
}

class Member {
  final int? id;
  final int groupId;
  final String name;
  final int orderIndex;

  Member({
    this.id,
    required this.groupId,
    required this.name,
    required this.orderIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'name': name,
      'orderIndex': orderIndex,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      groupId: map['groupId'],
      name: map['name'],
      orderIndex: map['orderIndex'],
    );
  }
}

class Payment {
  final int? id;
  final int groupId;
  final int memberId;
  final double amount;
  final int timestamp;
  final int? paidForMemberId; // Used for "paying on behalf"

  Payment({
    this.id,
    required this.groupId,
    required this.memberId,
    required this.amount,
    required this.timestamp,
    this.paidForMemberId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'memberId': memberId,
      'amount': amount,
      'timestamp': timestamp,
      'paidForMemberId': paidForMemberId,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      groupId: map['groupId'],
      memberId: map['memberId'],
      amount: map['amount'],
      timestamp: map['timestamp'],
      paidForMemberId: map['paidForMemberId'],
    );
  }
}

class Debt {
  final int? id;
  final int groupId;
  final int debtorId; // The person who was unavailable and needs to pay later
  final int creditorId; // The person who paid on behalf

  Debt({
    this.id,
    required this.groupId,
    required this.debtorId,
    required this.creditorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'debtorId': debtorId,
      'creditorId': creditorId,
    };
  }

  factory Debt.fromMap(Map<String, dynamic> map) {
    return Debt(
      id: map['id'],
      groupId: map['groupId'],
      debtorId: map['debtorId'],
      creditorId: map['creditorId'],
    );
  }
}
