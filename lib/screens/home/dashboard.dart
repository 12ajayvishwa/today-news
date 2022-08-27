import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todaynews/services/api_services.dart';
import 'package:todaynews/widgets/custom_appbar.dart';
import 'package:todaynews/widgets/custom_list_tile.dart';
import 'package:todaynews/widgets/logo_text.dart';
import '../../model/news_article_model.dart';
import '../signin_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;
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
            logoutTab: () async {
              await _auth.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SignInPage()));
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
