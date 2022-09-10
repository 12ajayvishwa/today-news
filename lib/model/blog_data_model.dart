class BlogModel{
  String? authorName;
  String? id;
  String? title;
  String? desc;
  String? date;
  String? time;
  String? url;
  String? blogKey;

  BlogModel(
    {this.authorName,this.id,this.title,this.desc,this.url,this.date,this.time,this.blogKey});
  
  //sending data to blog collection

  Map<String, dynamic> blogMap(){
    return {
       "imageUrl" : url ?? "",
      "authorName" : authorName ?? "",
      "title" : title ?? "",
      "desc" : desc ?? "",
    };
  }
toJson() {
  return {
    'imageUrl':url ?? "",
    'authorName':authorName ?? "",
    'title':title ?? "",
    'desc' : desc ?? "",
    'time' : time ?? "",
    'date' : date ?? "",
  };
}

BlogModel.fromJson(Map<String,dynamic> map){
  id = map['id'];
  authorName = map['authorName'];
  title = map['title'];
  desc = map['desc'];
  url = map['imageUrl'];
}
}