class TaskModel {
  String date;
  String fromTime;
  String toTime;
  String title;
  String type;
  List<String?> tasks;
  String? description;

  TaskModel({
    required this.date,
    required this.fromTime,
    required this.toTime,
    required this.title,
    required this.type,
    required this.tasks,
    this.description,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      date: json["date"],
      fromTime: json["fromTime"],
      toTime: json["toTime"],
      title: json["title"],
      type: json["type"],
      tasks: json["tasks"] != null ? List<String?>.from(json["tasks"]) : [],
      description: json["description"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "fromTime": fromTime,
      "toTime": toTime,
      "title": title,
      "type": type,
      "tasks": tasks,
      "description": description,
    };
  }
}
