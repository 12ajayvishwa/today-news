

class BlogModel{
  String? authorName;
  String? title;
  String? desc;
  String? url;

  BlogModel({this.authorName,this.title,this.desc,this.url});
  
  //sending data to blog collection

  Map<String, dynamic> blogMap(){
    return {
       "imageUrl" : url ?? "",
      "authorName" : authorName ?? "",
      "title" : title ?? "",
      "desc" : desc ?? "",
    };
  }
}