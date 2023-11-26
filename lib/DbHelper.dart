import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Future initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '.nomedia');

    final exist = await databaseExists(path);

    if (exist) {
      print('database already exits.');
      final db = await openDatabase(path);
      //db tables name
      // var tableName =
      //     (await db.query('sqlite_master', columns: ['type', 'name']))
      //         .forEach((element) {
      //   print(element.values);
      // });
      // print(tableName);

      // var value =
      //     await db.rawQuery("select more_mean from details where _id = 43073");

      // print(value);

      // var c = value.elementAt(0).values.last;

      // print(c);
      // int cc = int.parse(
      //     'B0468165E1B12170571077411590F1B1610791975145A15191305740D',
      //     radix: 16);
      // print(cc);
      // print(l);

      // var ts = await db.rawQuery('PRAGMA table_info(details_index)');
      // print(ts);

      // var value = await db.rawQuery("select count(1) from Favorite");
      // var value = await db.rawQuery("select * from antonyms where _id = 1");
      // print(value.toList());
      // var value = await db
      //     .rawQuery("select more_mean from alldata where word like 'good'");
      // // print(value.toList());
      // var dt = value.elementAt(0).values.first;
      // print(dt);
      return db;

      // String.format(Locale.forLanguageTag("bn"), "%d", 1234567890);
      // jsonDecode(utf8.decode(dt));

      // var st = dt.toString().transform(utf8.decoder);
      // var ant =
      //     await db.rawQuery("select * from antonyms where word like 'good'");
      // print(ant);
    } else {
      print('database not exits.');
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", '.nomedia'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);

      print('database copied.');
    }

    await openDatabase(path);
  }
}
