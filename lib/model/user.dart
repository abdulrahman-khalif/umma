class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? userType;
  String? regdate;
  String? otp;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.userType,
      this.regdate,
      this.otp});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    userType = json['user_type'];
    regdate = json['regdate'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['user_type'] = this.userType;
    data['regdate'] = this.regdate;
    data['otp'] = this.otp;
    return data;
  }
}
