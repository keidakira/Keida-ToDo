import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keida_todo/add-task.dart';
import 'package:keida_todo/database_helpers.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/add-task': (context) => AddTask()
    },
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool checkBoxValue = false;
  List<Map> tasksList;
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  readData() async {
    DatabaseHelper _databaseHelper = DatabaseHelper.instance;
    List<Map> tasks = await _databaseHelper.getAllTasks();
    print(tasks);

    setState(() {
      tasksList = tasks;
    });

    return tasks;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Tasks'),
          elevation: 0,
        ),
        body: Container(
          color: Color(0xFFF1F1F1),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: FutureBuilder<List<Map>>(
                    future: _databaseHelper.getAllTasks(),
                    builder: (BuildContext ctx, AsyncSnapshot<List<Map>> snapshot) {
                      if(snapshot.hasData) {
                        // Show data
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(
                                  snapshot.data[index]['task'],
                                  style: TextStyle(
                                    decoration: snapshot.data[index]['status'] == 1?TextDecoration.lineThrough:null
                                  ),
                                ),
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) => AlertDialog(
                                      title: new Text("Delete this task?"),
                                      content: new Text("Once deleted cannot be undone!"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            this._databaseHelper.delete(snapshot.data[index]['_id']);
                                            setState((){});
                                            Navigator.of(ctx).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('No'),
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                        ),
                                      ],
                                    )
                                  );
                                },
                                trailing: Checkbox(
                                  onChanged: (bool value) {
                                    Map<String, dynamic> newData = {};
                                    newData['_id'] = snapshot.data[index]['_id'];
                                    newData['task'] = snapshot.data[index]['task'];
                                    newData['status'] = value == true?1:0;
                                    this._databaseHelper.updateStatus(newData);
                                    setState(() {});
                                  },
                                  value: snapshot.data[index]['status'] == 0?false:true,
                                  activeColor: Colors.green,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return null;
                    },
                  )
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            dynamic refresh = await Navigator.push(
              context,
              MaterialPageRoute<dynamic>(builder: (context) => AddTask())
            );
            if(refresh != null)
              setState(() {});
          },
          child: Icon(
            Icons.add
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
