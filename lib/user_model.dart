class UserProfileData {
  String? id, userName, password, userEmail, phonenumber, role;
  UserProfileData({
    this.id,
    this.userEmail,
    this.userName,
    this.password,
    this.phonenumber,
    this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userPassword': password,
      'userEmail': userEmail,
      'Role': role,
    };
  }

  UserProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userEmail = json['userEmail'];
    userName = json['userName'];
    role = json['Role'];
    password = json['userPassword'];
  }

  @override
  String toString() {
    return 'UserProfileData{id:$id,userName:$userName,userPassword:$password,userEmail:$userEmail,role:$role}';
  }
}

List<UserProfileData> userdata = [];
//UserProfileData user = UserProfileData();
UserProfileData newuUser = UserProfileData();
