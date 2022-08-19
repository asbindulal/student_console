class UserModel {
  String? uid;
  String? email;
  String? fullname;
  String? phonenumber;
  String? batch;
  String? faculty;
  String? semester;
  String? section;
  String? avatar;
  String? user;

  UserModel({
    this.uid,
    this.email,
    this.fullname,
    this.phonenumber,
    this.batch,
    this.faculty,
    this.section,
    this.semester,
    this.avatar,
    this.user,
  });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullname: map['fullname'],
      phonenumber: map['phonenumber'],
      batch: map['batch'],
      faculty: map['faculty'],
      section: map['section'],
      semester: map['semester'],
      avatar: map['avatar'],
      user: map['user'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'phonenumber': phonenumber,
      'batch': batch,
      'faculty': faculty,
      'section': section,
      'semester': semester,
      'avatar': avatar,
      'user': user,
    };
  }
}
