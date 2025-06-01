import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main(){
  runApp(GitHupApp());
}
class GitHupApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'GitHupApp',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: GitHupAppPage(),
    );
  }
}
class GitHupAppPage extends StatefulWidget{
  GitHupAppPageState createState()=> GitHupAppPageState();
}
class GitHupAppPageState extends State<GitHupAppPage>{
  TextEditingController controller=TextEditingController();
  Map<String,dynamic>? profile;
  List repos=[];
  bool isLoading=false;

  Future<void> GitHup(String username) async{
    setState(() {
      isLoading=true;
    });
    final userUrl='https://api.github.com/users/$username';
    final reposUrl='https://api.github.com/users/$username/repos';
    final userRes= await http.get(Uri.parse(userUrl));
    final reposRes=await http.get(Uri.parse(reposUrl));
      if(userRes.statusCode==200&&reposRes.statusCode==200){
        setState(() {
          profile=jsonDecode(userRes.body);
          repos=jsonDecode(reposRes.body);
          isLoading=false;
        });
      }else{
        setState(() {
          profile=null;
          repos=[];
          isLoading=false;
        });
      }
  }
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:Text("githup profile viewer"),
      ),
      body:Padding(
        padding:EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText:'enter the username',
                border: OutlineInputBorder(),

              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: ()=>GitHup(controller.text),
                child: Text('fetch profile'),
            ),
            if(isLoading) ...[
              SizedBox(height: 20,),
          CircularProgressIndicator(),
            ],
            if(profile!=null)...[
              SizedBox(height: 20,),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(profile!['avatar_url']),
              ),
              SizedBox(height: 10,),
              Text(profile!['name']?? 'noname',
    style: TextStyle(fontSize: 19,
    fontWeight: FontWeight.bold),
    ),
    Text(profile!['bio']?? 'no bio'),
                  Divider(),
              Text('Repositories',
    style: TextStyle(fontWeight: FontWeight.bold)
              ),

              Expanded(
    child: ListView.builder(
    itemCount: repos.length,
    itemBuilder: (context,index){
      return ListTile(
      title: Text(repos[index]['name']),
      subtitle: Text(repos[index]['language']??'unknown'),
      );

    }
    ),
    )
              
            ],
          ],
        ),

      )
    );
  }
}