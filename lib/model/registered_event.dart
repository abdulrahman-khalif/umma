class Registered_event {
  String? id;
  String? userId;
  String? eventId;
  String? eventTitle;
  String? eventDesc;
  String? speaker;
  String? registeredDate;

  Registered_event(
      {this.id,
      this.userId,
      this.eventId,
      this.eventTitle,
      this.eventDesc,
      this.speaker,
      this.registeredDate});

  Registered_event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    eventId = json['event_id'];
    eventTitle = json['event_title'];
    eventDesc = json['event_desc'];
    speaker = json['speaker'];
    registeredDate = json['registered_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['event_id'] = this.eventId;
    data['event_title'] = this.eventTitle;
    data['event_desc'] = this.eventDesc;
    data['speaker'] = this.speaker;
    data['registered_date'] = this.registeredDate;
    return data;
  }
}
