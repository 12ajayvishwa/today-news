

class Blog{
  String? authorName;
  String? title;
  String? desc;
  String? date;
  String? time;
  String? url;
  String? blogKey;

  Blog(
    {this.authorName,this.title,this.desc,this.url,this.date,this.time,this.blogKey});
  
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
}