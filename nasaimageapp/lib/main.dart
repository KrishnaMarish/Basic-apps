import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(){
runApp(NasaImage());
}
class NasaImage extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Nasa imager',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: NasaImagePage(),
    );
  }
}
class NasaImagePage extends StatefulWidget{
  NasaImagePageState createState()=> NasaImagePageState();
}
class NasaImagePageState extends State<NasaImagePage>{
  String imageUrl='';
  String title='';
  String explanation='';
  bool isLoading=false;
  
  Future<void> Nasa() async{
    setState(() {
      isLoading=true;
    });
    final url=Uri.parse('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY');
     try{
       final response= await http.get(url);
       if(response.statusCode==200){
         final data=jsonDecode(response.body);
         setState(() {
           imageUrl=data['url'];
           title=data['title'];
           explanation=data['explanation'];
           isLoading=false;
         });
       }
     }
     catch(opj){
       setState(() {
         isLoading=false;
       });
     }
  }

  void initState(){
    super.initState();
    Nasa();
  }
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Nasa Image Viewer'),
      ),
      body: isLoading?
          Center(
            child: CircularProgressIndicator(),
          ):
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                Image.network(imageUrl),
                SizedBox(
                  height: 20,
                ),
                Text(explanation,
                style: TextStyle(
                  fontSize: 16
                ),
                textAlign: TextAlign.justify,),
              ],
            ),
          ),
    );
  }
}