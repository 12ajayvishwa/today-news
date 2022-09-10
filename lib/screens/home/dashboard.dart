import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todaynews/screens/user_profile_page.dart';
import 'package:todaynews/services/api_services.dart';
import 'package:todaynews/widgets/custom_appbar.dart';
import 'package:todaynews/widgets/custom_list_tile.dart';
import 'package:todaynews/widgets/logo_text.dart';
import '../../model/news_article_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ApiServices client = ApiServices();

  bool isLoading = false;

  void loading() {}

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
            title: LogoText(firstText: "NEWS", secondText: "TODAY"),
            icon: const Icon(Icons.logout),
            profileTab: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const UserProfilePage()));
            },
          ),
        ),
        body: FutureBuilder(
          future: client.getArticle(),
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
}
