class Member {
  String? message;
  String? memId;
  String? memFullname;
  String? memUsername;
  String? memPassword;
  String? memEmail;
  String? memAge;

  Member(
      {this.message,
      this.memId,
      this.memFullname,
      this.memUsername,
      this.memPassword,
      this.memEmail,
      this.memAge});

  Member.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    memId = json['memId'];
    memFullname = json['memFullname'];
    memUsername = json['memUsername'];
    memPassword = json['memPassword'];
    memEmail = json['memEmail'];
    memAge = json['memAge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['memId'] = this.memId;
    data['memFullname'] = this.memFullname;
    data['memUsername'] = this.memUsername;
    data['memPassword'] = this.memPassword;
    data['memEmail'] = this.memEmail;
    data['memAge'] = this.memAge;
    return data;
  }
}
