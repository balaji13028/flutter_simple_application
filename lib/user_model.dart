class UserProfileData {
  String? id, userName, password, userEmail, phonenumber, Role;
  UserProfileData({
    this.id,
    this.userEmail,
    this.userName,
    this.password,
    this.phonenumber,
    this.Role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'password': password,
      'userEmail': userEmail,
      'Role': Role,
    };
  }

  @override
  String toString() {
    return 'UserProfileData{id:$id,userName:$userName,password:$password,userEmail:$userEmail,phonenumber:$phonenumber,Role:$Role}';
  }
}

List<UserProfileData> userdata = [];
UserProfileData newUser = UserProfileData();
