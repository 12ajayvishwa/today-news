import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context){
    return [IconButton(onPressed: (){}, icon: Icon(Icons.clear))];
  }
  @override
 Widget buildLeading(BuildContext context){
    return IconButton(
      onPressed: (){}, 
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow,progress: transitionAnimation,));
  }
  @override
  Widget buildResults(BuildContext context){
    return Text("hi");
  }
  @override
  Widget buildSuggestions(BuildContext context){
    return Text("data");
  }
  


}