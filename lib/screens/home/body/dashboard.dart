import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todaynews/model/blog_data_model.dart';
import 'package:todaynews/screens/blogs/components/blog_details_page.dart';
import 'package:todaynews/screens/blogs/components/favourite_blog_page.dart';
import 'package:todaynews/screens/home/components/search_function.dart';
import 'package:todaynews/screens/profile_page/user_profile_page.dart';
import 'package:todaynews/services/api_services/api_services.dart';
import 'package:todaynews/widgets/custom_appbar.dart';
import 'package:todaynews/widgets/custom_list_tile.dart';
import 'package:todaynews/widgets/logo_text.dart';
import '../../../model/news_article_model.dart';
import '../../../model/user_data.dart';
import '../../../widgets/search_function.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ApiServices client = ApiServices();
  UserModel loggedInUser = UserModel();

  bool isLoading = false;
  List<Article> articles = [];
  String query = '';
  Timer? debouncer;
  bool isSearching = false;
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(VoidCallback callback,
      {Duration duration = const Duration(milliseconds: 1000)}) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final articles = await ApiServices.getArticle(query);

    setState(() {
      this.articles = articles;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setState(() {
      isLoading = true;
    });
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.08),
          child: CustomAppBar(
            color: const Color.fromARGB(31, 247, 241, 241),
            title: 
            
            LogoText(firstText: "NEWS", secondText: "TODAY"),
            favouriteIcon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            userProfile: loggedInUser == ""
                ? CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(loggedInUser.url ?? ""),
                    //  child: Icon(Icons.person,color: Colors.red,size: 35,),
                  )
                : Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
            logoutTab: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FavouriteBLog()));
            },
            profileTab: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const UserProfilePage()));
            },
            searchTab: () {
              buildSearch();
              showSearch(context: context, delegate: DataSearch());
            },
            searchIcon: Icons.search,
          ),
        ),
        body: FutureBuilder(
          future: ApiServices.getArticle(query),
          builder:
              (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
            if (snapshot.hasData) {
              List<Article> articles = snapshot.data!;
              return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) =>
                      custtomListTile(articles[index], context));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Widget buildSearch() => SearchFunctionality(
        hintText: "Title or Author Name",
        text: query,
        onChanged: searchArticle,
      );
  Future searchArticle(String query) async => debounce(() async {
    final article = await ApiServices.getArticle(query);

    if(!mounted) return;

    setState(() {
      this.query = query;
      this.articles = articles;
    });

  Widget buildArticle(Article article){
    return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) =>
                      custtomListTile(articles[index], context));
            }
  });
}
