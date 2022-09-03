class UserModel{
  String? name;
  String? email;
  String? address;
  String? phoneNumber;
  String? url;
  String? uid;

  UserModel({this.name,this.email,this.address,this.phoneNumber,this.uid,this.url});

  // receiving data from server

  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      url: map['url']
    );
  }

  //sending data to server

  Map<String, dynamic> toMap(){
    return {
      'uid':uid,
      'name':name,
      'email':email,
      'address':address,
      'phoneNumber':phoneNumber,
    };
  }
}