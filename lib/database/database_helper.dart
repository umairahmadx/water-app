import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('water_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE groups (
        id $idType,
        name $textType,
        amount $realType,
        turnIndex $integerType DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE members (
        id $idType,
        groupId $integerType,
        name $textType,
        orderIndex $integerType,
        FOREIGN KEY (groupId) REFERENCES groups (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE payments (
        id $idType,
        groupId $integerType,
        memberId $integerType,
        amount $realType,
        timestamp $integerType,
        paidForMemberId INTEGER,
        FOREIGN KEY (groupId) REFERENCES groups (id) ON DELETE CASCADE,
        FOREIGN KEY (memberId) REFERENCES members (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE debts (
        id $idType,
        groupId $integerType,
        debtorId $integerType,
        creditorId $integerType,
        FOREIGN KEY (groupId) REFERENCES groups (id) ON DELETE CASCADE,
        FOREIGN KEY (debtorId) REFERENCES members (id) ON DELETE CASCADE,
        FOREIGN KEY (creditorId) REFERENCES members (id) ON DELETE CASCADE
      )
    ''');
  }

  // Group Operations
  Future<int> insertGroup(Group group) async {
    final db = await instance.database;
    return await db.insert('groups', group.toMap());
  }

  Future<List<Group>> getGroups() async {
    final db = await instance.database;
    final result = await db.query('groups');
    return result.map((json) => Group.fromMap(json)).toList();
  }

  Future<int> updateGroup(Group group) async {
    final db = await instance.database;
    return await db.update(
      'groups',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
  }

  Future<int> deleteGroup(int id) async {
    final db = await instance.database;
    return await db.delete(
      'groups',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Member Operations
  Future<int> insertMember(Member member) async {
    final db = await instance.database;
    return await db.insert('members', member.toMap());
  }

  Future<List<Member>> getMembers(int groupId) async {
    final db = await instance.database;
    final result = await db.query(
      'members',
      where: 'groupId = ?',
      whereArgs: [groupId],
      orderBy: 'orderIndex ASC',
    );
    return result.map((json) => Member.fromMap(json)).toList();
  }

  Future<int> updateMember(Member member) async {
    final db = await instance.database;
    return await db.update(
      'members',
      member.toMap(),
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  Future<int> deleteMember(int id) async {
    final db = await instance.database;
    return await db.delete(
      'members',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Payment Operations
  Future<int> insertPayment(Payment payment) async {
    final db = await instance.database;
    return await db.insert('payments', payment.toMap());
  }

  Future<List<Payment>> getPayments(int groupId) async {
    final db = await instance.database;
    final result = await db.query(
      'payments',
      where: 'groupId = ?',
      whereArgs: [groupId],
      orderBy: 'timestamp DESC',
    );
    return result.map((json) => Payment.fromMap(json)).toList();
  }

  // Debt Operations
  Future<int> insertDebt(Debt debt) async {
    final db = await instance.database;
    return await db.insert('debts', debt.toMap());
  }

  Future<List<Debt>> getDebts(int groupId) async {
    final db = await instance.database;
    final result = await db.query(
      'debts',
      where: 'groupId = ?',
      whereArgs: [groupId],
    );
    return result.map((json) => Debt.fromMap(json)).toList();
  }

  Future<int> deleteDebt(int id) async {
    final db = await instance.database;
    return await db.delete(
      'debts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
