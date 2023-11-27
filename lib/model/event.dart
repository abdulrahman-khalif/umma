class Event {
  String? id;
  String? userId;
  String? eventTitle;
  String? eventDesc;
  String? speaker;
  String? eventDate;
  String? duedate;

  Event(
      {this.id,
      this.userId,
      this.eventTitle,
      this.eventDesc,
      this.speaker,
      this.eventDate,
      this.duedate});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    eventTitle = json['event_title'];
    eventDesc = json['event_desc'];
    speaker = json['speaker'];
    eventDate = json['event_date'];
    duedate = json['duedate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['event_title'] = this.eventTitle;
    data['event_desc'] = this.eventDesc;
    data['speaker'] = this.speaker;
    data['event_date'] = this.eventDate;
    data['duedate'] = this.duedate;
    return data;
  }
}
