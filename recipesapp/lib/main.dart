import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(){
  runApp(RecipesApp());
}
class RecipesApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Recipes',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: RecipesAppPage(),
    );
  }
}
class RecipesAppPage extends StatefulWidget{
  RecipesAppPageState createState()=>  RecipesAppPageState();
}
class RecipesAppPageState extends State<RecipesAppPage>{
  List recipes=[];
  bool isLoading=false;
  final apikey='bb6642abecb244938a409150cf933409';
  TextEditingController controller=TextEditingController();
  Future<void> re_cipes(String query) async{
    setState(() {
      isLoading=true;
    });
    final url=Uri.parse('https://api.spoonacular.com/recipes/complexSearch?query=$query&addRecipeInformation=true&apiKey=$apikey');
    final response= await http.get(url);
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      setState(() {
        recipes=data['results'];
        isLoading=false;
      });
    }
  }
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Finder'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'search recipes',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: ()=>re_cipes(controller.text),
              child: Text('Search'),
            ),
            SizedBox(height: 20,),
            if(isLoading)CircularProgressIndicator(),
            if(!isLoading && recipes.isNotEmpty)
              Expanded(child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context,index){
                    final rec=recipes[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: Image.network(
                          rec['image'],
                          width: 80,
                          fit: BoxFit.cover,

                        ),
                        title: Text(rec['title']),
                        subtitle: Text(rec['summary']),
                      ),
                    );
                  }
              )
              )

          ],
        ),
      ),
    );

  }
}