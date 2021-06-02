import 'package:flutter/material.dart';
import 'package:todo/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController tit = TextEditingController();
  final TextEditingController discription = TextEditingController();

  var ind;

  @override
  void initState() {
    super.initState();
    getData();
    ind = 0;
  }

  List<EachModel> allList = [];
  void addTodo({t, d}) {
    setState(() {
      allList.add(EachModel(t.toString(), d.toString()));
    });
    saveJson();
    tit.text = "";
    discription.text = "";
  }

  void EditTodo({t, d, i}) {
    setState(() {
      if (i != null) {
        allList[i].title = t;
        allList[i].des = d;
      }
    });
    saveJson();
    tit.text = "";
    discription.text = "";
  }

  void saveJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String raw = jsonEncode(allList.toList());
    print(raw);
    prefs.setString("todos", raw);
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var data = prefs.getString("todos");
    print(data);

    if (data == null) {
      print("Data null");
    } else {
      setState(() {
        List<EachModel> all = jsonDecode(data);
        print(all);
      });
    }
  }

  void deleteTodo({i}) {
    setState(() {
      allList.removeAt(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO App"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: tit,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hintText: "Title"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: discription,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hintText: "Description"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print(discription.text);
                          print(tit.text);

                          addTodo(t: tit.text, d: discription.text);
                        },
                        child: Text("Save"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print(discription.text);
                          print(tit.text);

                          EditTodo(t: tit.text, d: discription.text, i: ind);
                        },
                        child: Text("Edit"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  allList.isEmpty
                      ? Container()
                      : Container(
                          height: 2000,
                          child: Expanded(
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: allList.length,
                                itemBuilder: (BuildContext context, i) {
                                  var title = allList[i].title.toString();
                                  var des = allList[i].des.toString();
                                  print(title);
                                  return Card(
                                    elevation: 0,
                                    color: Colors.grey[300],
                                    child: ListTile(
                                      title: Text(
                                        title,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        des,
                                      ),
                                      trailing: Column(
                                        children: [
                                          InkWell(
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.green,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                ind = i;
                                              });

                                              tit.text =
                                                  allList[i].title.toString();
                                              discription.text =
                                                  allList[i].des.toString();
                                            },
                                          ),
                                          InkWell(
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onTap: () {
                                              deleteTodo(i: i);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
