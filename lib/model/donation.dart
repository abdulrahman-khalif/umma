class Donation {
  String? userId;
  String? userName;
  String? eventId;
  String? eventName;
  String? amount;
  String? state;
  String? date;

  Donation(
      {this.userId,
      this.userName,
      this.eventId,
      this.eventName,
      this.amount,
      this.state,
      this.date});

  Donation.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    eventId = json['event_id'];
    eventName = json['event_name'];
    amount = json['amount'];
    state = json['state'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['event_id'] = this.eventId;
    data['event_name'] = this.eventName;
    data['amount'] = this.amount;
    data['state'] = this.state;
    data['date'] = this.date;
    return data;
  }
}
