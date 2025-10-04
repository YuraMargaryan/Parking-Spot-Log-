import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
part 'database.g.dart';


class TableJournal extends Table{
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  RealColumn get price => real()();
  TextColumn get conditions => text().nullable()();
}

class TablePush extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get remindAt => dateTime()();// когда напомнить
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

}

class TableMap extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  TextColumn get address => text()();

  RealColumn get latitude => real()();
  RealColumn get longitude => real()();

}

class TableNote extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // когда создана
}

@DriftDatabase(tables: [TableJournal,TablePush,TableMap,TableNote])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

 @override
  int get schemaVersion => 1;

       // ---- Journal CRUD ----
 Future <int> addJournal(TableJournalCompanion entry) =>
       into(tableJournal).insert(entry);

 Future <List<TableJournalData>> gettAllJournal() =>
       select(tableJournal).get();

 Stream <List<TableJournalData>> watchJournal() =>
      select(tableJournal).watch();

 Future <int> deleteJournal(int id)=>
      (delete(tableJournal)..where((i)=> i.id.equals(id))).go();

     // ---- Push CRUD ----
 Future<int> addPush(TablePushCompanion push) =>
      into(tablePush).insert(push);

 Future <List<TablePushData>> gettAllPushes() =>
      select(tablePush).get();

 Stream <List<TablePushData>> watchPushes() =>
      select(tablePush).watch();

 Future <int> deletePushes(int id) =>
      (delete(tablePush)..where((i)=> i.id.equals(id))).go();

      // ---- Map CRUD ----
 Future<int> addMap (TableMapCompanion map) =>
      into(tableMap).insert(map);

 Future<List<TableMapData>> gettAllMap() =>
      select(tableMap).get();

 Stream<List<TableMapData>> watchMap() =>
      select(tableMap).watch();

 Future <int> deleteMap (int id) =>
      (delete(tableMap)..where((i)=> i.id.equals(id))).go();

      // ---- Note CRUD ----
 Future<int> addNote (TableNoteCompanion note) =>
      into(tableNote).insert(note);

 Future<List<TableNoteData>> gettAllNote () =>
      select(tableNote).get();

 Stream<List<TableNoteData>> watchNote() =>
      select(tableNote).watch();

 Future<int>  deleteNote (int id) =>
      (delete(tableNote)..where((i)=> i.id.equals(id))).go();



}
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}

