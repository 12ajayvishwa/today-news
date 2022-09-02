class UserModel{
  String? name;
  String? email;
  String? address;
  String? phoneNumber;
  String? imageUrl;
  String? uid;

  UserModel({this.name,this.email,this.address,this.phoneNumber,this.uid,this.imageUrl});

  // receiving data from server

  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map['imageUrl']
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
      'imageUrl' : imageUrl
    };
  }
}