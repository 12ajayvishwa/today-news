class NewsSource{
  String? id;
  String? name;

  NewsSource({this.id,this.name});

  factory NewsSource.fromJson(Map<String,dynamic> json){
    return NewsSource(
      id: json['id'],
      name: json['name']
    );
  }
}