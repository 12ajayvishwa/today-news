import 'package:flutter/material.dart';
import 'package:todaynews/screens/home/body/dashboard.dart';
import 'package:todaynews/screens/home/components/home.dart';

import '../../../model/news_article_model.dart';
import '../../../services/api_services/api_services.dart';
import '../../../widgets/custom_list_tile.dart';

class DataSearch extends SearchDelegate<String>{
  List<Article> articles = [];
  List<Article> filteredArticles = [];
  ApiServices client = ApiServices();
  bool isLoading = false;

  final recentSearch = ["Rahul Gandhi","News 18","Hindustan Times"];
  @override
  List<Widget> buildActions(BuildContext context){
    return [IconButton(onPressed: (){
      query = "";
    }, icon: Icon(Icons.clear))];
  }
  @override
 Widget buildLeading(BuildContext context){
    return IconButton(
      onPressed: (){
        close(context, "");
      }, 
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow,progress: transitionAnimation,));
  }
  @override
  Widget buildResults(BuildContext context){
    return Center(child: Text("You Search for ${query}",style: TextStyle(fontFamily: "Lato",fontSize: 25),));
  }
  @override
  Widget buildSuggestions(BuildContext context){
    final seggestionList = query.isEmpty ? recentSearch:articles;
    return FutureBuilder(
          future: ApiServices.getArticle(query),
          builder:
              (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
            if (snapshot.hasData) {
              List<Article> articles = snapshot.data!;
              return ListView.builder(
                  itemCount: seggestionList.length,
                  itemBuilder: (context, index) =>
                      custtomListTile(articles[index], context));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
  }
  


}