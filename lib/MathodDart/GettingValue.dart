import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_player/DbHelper.dart';
import 'package:live_player/java/GettingValue.dart';
import 'package:logger/logger.dart';

void main() => runApp(const _MyApp());

class _MyApp extends StatefulWidget {
  const _MyApp({super.key});

  String get title => 'My Data';

  @override
  State<_MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> {
  final String title = 'My Data';
  // DbHelper db = DbHelper();
  DbHelper db = DbHelper();
  Future<dynamic>? access;
  bool isButtonPrassed = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              // Text("text"),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    try {
                      isButtonPrassed = true;
                      // access = dbWork(isButtonPrassed);
                      // access = db.initDb();
                    } catch (_) {
                      print('Fetch error');
                    }
                  });
                },
                child: Icon(
                  Icons.add,
                ),
              ),
              if (isButtonPrassed)
                SingleChildScrollView(
                  // scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: dbWork(isButtonPrassed),
                        // future: access,
                        builder: (context,
                            AsyncSnapshot<Map<String, Map<String, String>>>
                                snapshot) {
                          if (!snapshot.hasData) {
                            isButtonPrassed = false;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            isButtonPrassed = false;
                            return Text("Error");
                          } else {
                            if (snapshot.data != null) {
                              print('snapshot.data');
                              Map<String, Map<String, String>> myMap =
                                  Map.from(snapshot.data!);
                              var mKeyList = myMap.keys.toList();
                              print(myMap.keys);
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  // itemExtent: 90,
                                  itemCount: myMap.length - 1,
                                  itemBuilder: (context, index) {
                                    Map<String, String>? sMap =
                                        myMap[mKeyList[index + 1]];
                                    var sMapKey = sMap!.keys.toList();

                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      // alignment: Alignment.topLeft,
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Container(
                                            // height: 100,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(mKeyList[index + 1]),
                                                Expanded(
                                                  // child: SafeArea(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: SafeArea(
                                                      child: ListView.builder(
                                                        // scrollDirection:
                                                        //     Axis.vertical,
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            sMapKey.length,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        1.0),
                                                            child: Stack(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                        sMapKey[
                                                                            i]),
                                                                    Text(sMap[
                                                                        sMapKey[
                                                                            i]]!),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );

                                                          // );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    //   ],
                                    // );
                                  },
                                ),
                              );
                              // ),
                              //     ],
                              //   ),
                              // );
                            } else {
                              return Text('Data not found');
                            }
                          }
                        },
                      ),
                      // ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, Map<String, String>>> dbWork(res) async {
    var detailsKey = [
      '_id',
      'pronunciation',
      'more_mean',
      'definition',
      'synonyms',
      'x1',
      'x2'
    ];
    GettingValue gv = GettingValue();
    print(res);
    print('Button click');
    // print(res);
    var d = await db.initDb();
    var value;
    var logger = Logger();
    if (res) {
      // value =
      //     await d.rawQuery("select more_mean from details where _id = 43073");
      // value = await d?.query('details', where: "_id = 43073");
      value = await d?.query('details',
          columns: [
            '_id',
            'pronunciation',
            'more_mean',
            'definition',
            'synonyms',
            'x1',
            'x2'
          ],
          where: "_id = 43073");

      Map<String, Map<String, String>> mapAll = <String, Map<String, String>>{};
      detailsKey.forEach((element) {
        Map<String, String> mab = Map();
        print('----------loop----------------');
        print('details key: $element');
        print(value[0]['$element']);
        if (value[0]['$element'].runtimeType != int &&
            value[0]['$element'] != null) {
          mab = gv.convert2Map(value[0]['$element']);
        }

        // print(value[0]['synonyms']);
        // mab = gv.convert2Map(value[0]['synonyms']);
        print('=======>>>>>');
        print(mab);
        print(mab['ভাল']);

        mapAll.putIfAbsent(element, () => mab);
      });

      //

      return mapAll;
      // return value;
    } else {
      res = true;
      return <String, Map<String, String>>{};
      // return const Text("data not found");
    }
  }

  bool txt(bool res) {
    if (res) {
      return false;
    } else {
      return true;
    }
  }

  void prints(var s1) {
    String s = s1.toString();
    debugPrint(" =======> " + s, wrapWidth: 1024);
  }

  // Function to extract content within curly braces for a specific category
  List<String> extractContent(String input, String category) {
    RegExp regex = RegExp('$category\\{(.*?)\\}', multiLine: true);
    Match? match = regex.firstMatch(input);
    if (match != null) {
      return match.group(1)?.split(';') ?? [];
    }
    return [];
  }

// Function to create an array by splitting content
  List<String> createArray(List<String> content) {
    List<String> result = [];
    for (String entry in content) {
      List<String> parts = entry.trim().split(':');
      if (parts.length == 2) {
        result.add(parts[1].trim());
      }
    }
    return result;
  }

  // Map<String, String> array2Map(List<String> abAry) {
  //   Map<String, String> mab = {};
  //   for (String item in abAry) {
  //     if (item.length > 1) {
  //       var [key, value] = item.trim().split(':');
  //       mab[key] = value;
  //     }
  //   }
  //   return mab;
  // }
}

class alldata {
  int? _id;
  String? word;
  String? common_mean;
  String? more_mean;
  String? noun;
  String? pronoun;
  String? adjective;
  String? verb;
  String? adverb;
  String? preposition;
  String? conjunction;
  String? article;
  String? definitions;
  String? examples;
  String? synonyms;
}
