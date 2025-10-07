import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shifaa_cache.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE appointments ( 
        id INTEGER NOT NULL,
        type TEXT NOT NULL,
        doctor_name TEXT NOT NULL,
        specialty_name TEXT NOT NULL,
        avatar TEXT NULL,
        start_time TEXT NOT NULL,
        PRIMARY KEY (id, type)
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE appointments ADD COLUMN type TEXT NOT NULL DEFAULT 'unknown'",
      );
      await db.execute(
        "ALTER TABLE appointments ADD COLUMN startTime TEXT NOT NULL DEFAULT ''",
      );
    }
    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE appointments RENAME COLUMN doctorName TO doctor_name",
      );
      await db.execute(
        "ALTER TABLE appointments RENAME COLUMN specialty TO specialty_name",
      );
      await db.execute(
        "ALTER TABLE appointments RENAME COLUMN imageUrl TO avatar",
      );
      await db.execute(
        "ALTER TABLE appointments RENAME COLUMN startTime TO start_time",
      );

      await db.execute("ALTER TABLE appointments DROP COLUMN date");
      await db.execute("ALTER TABLE appointments DROP COLUMN time");
      print("✅ Database upgraded to version 3.");
    }
  }

  Future<void> cacheAppointments(
    List<AppointmentEntity> appointments,
    String type,
  ) async {
    final db = await instance.database;
    final batch = db.batch();

    batch.delete('appointments', where: 'type = ?', whereArgs: [type]);

    for (final appointment in appointments) {
      batch.insert('appointments', {
        'id': appointment.id,
        'type': type,
        'doctor_name': appointment.doctorName,
        'specialty_name': appointment.specialty,
        'avatar': appointment.imageUrl,
        'start_time': appointment.startTime,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<AppointmentEntity>> getCachedAppointments(String type) async {
    final db = await instance.database;

    final maps = await db.query(
      'appointments',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'start_time ASC',
    );

    return maps.map((json) {
      final startTimeString = json['start_time'] as String;
      final startTime = DateTime.parse(startTimeString);
      return AppointmentEntity(
        id: json['id'] as int,
        doctorName: json['doctor_name'] as String,
        specialty: json['specialty_name'] as String,
        imageUrl: json['avatar'] as String?,
        date: DateFormat('d MMMM, EEEE').format(startTime),
        time: DateFormat('h:mm a').format(startTime),
        startTime: startTimeString,
      );
    }).toList();
  }
}
