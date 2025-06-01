import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(){
  runApp(JokeApp());
}
class JokeApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'JokeApp',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: JokeAppPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class JokeAppPage extends StatefulWidget{
  JokeAppPageState createState()=> JokeAppPageState();
}
class JokeAppPageState extends State<JokeAppPage> {
  String setup = '';
  String punchline = '';
  bool isLoading = false;

  Future<void> Joke() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://official-joke-api.appspot.com/random_joke');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      setState(() {
        setup = data['setup'];
        punchline = data['punchline'];
      });
    } else{
    setup='failed to fetch joke';
    punchline='';
    }
  }catch (obj){
  setup='something is wrong';
  punchline='';
  }
  finally{
  setState(() {
  isLoading=false;
  });
  }
}
void initState() {
  super.initState();
  Joke();
}


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke are make smile'),
      ),
      body: Center(
        child: isLoading?
            CircularProgressIndicator():
            Padding(
                padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(setup,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(punchline,
                style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,),
                SizedBox(height: 40,),
                ElevatedButton(onPressed: Joke, child: Text('another joke '),
                ),
              ],
            ),
            ),
      ),
    );
  }
}