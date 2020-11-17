class Task {
  String task;
  bool status;

  Task({this.task, this.status});

  Map<String, dynamic> toJson() => {
    "task": this.task,
    "status": this.status
  };
}