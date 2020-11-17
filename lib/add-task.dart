import 'package:flutter/material.dart';
import 'package:keida_todo/database_helpers.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String task;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('New Task'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create a new task to add it to your ToDo list'),
              TextField (
                decoration: InputDecoration(
                  hintText: 'Enter Name',
                  contentPadding: EdgeInsets.only(bottom: -12)
                ),
                onChanged: (value) => {
                  setState(() {
                    task = value;
                  })
                },
              ),
              SizedBox(height: 8,),
              FlatButton(
                child: Text('Create Task'),
                onPressed: () async {
                  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

                  Task _task = new Task();
                  _task.status = 0;
                  _task.id = await _databaseHelper.getLastId() + 1;
                  _task.task = task;

                  int id = await _databaseHelper.insert(_task);
                  print(id);

                  Navigator.pop(context, true);
                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: double.infinity,
                padding: EdgeInsets.all(12),
              )
            ],
          ),
        ),
      ),
    );
  }
}
