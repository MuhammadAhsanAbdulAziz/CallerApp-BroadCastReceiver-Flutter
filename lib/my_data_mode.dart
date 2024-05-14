class MyDataModel {
  int? id;
  String? name;
  String? date;
  String? time;
  String? state;

  MyDataModel({required this.id, required this.name, required this.date, required this.time, required this.state});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'time': time,
      'state': state,
    };
  }

  MyDataModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    date = map['date'];
    time = map['time'];
    state = map['state'];
  }
}
