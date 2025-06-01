import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(){
  runApp(AnimalImage());
}
class AnimalImage extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Image Viewer',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: AnimalPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class AnimalPage extends StatefulWidget{
  AnimalPageState createState()=> AnimalPageState();
}

class AnimalPageState extends State<AnimalPage>{
  String imageUrl='';
  bool isLoading=false;
  
  Future<void> CatFetch() async {
  setState(() {
    isLoading= true;
  });
       final url=Uri.parse('https://api.thecatapi.com/v1/images/search');
          try{
            final response= await http.get(url);
            if(response.statusCode==200){
              final data=jsonDecode(response.body);
              setState(() {
                imageUrl=data[0]['url'];
              });
            }
          }catch (opj){
            imageUrl='';
          }finally{
            setState(() {
              isLoading=false;
            });
          }
  }

  Future<void> DogFetch() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('https://dog.ceo/api/breeds/image/random');
    ;

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          imageUrl = data['message'];
        });
      }
    } catch (obj) {
      imageUrl = '';
    }
    finally {
      isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CatFetch();
  }
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('cute animal viewer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(isLoading)
            CircularProgressIndicator()
          else if(imageUrl.isNotEmpty)
            Image.network(imageUrl,height: 300,fit: BoxFit.cover ,),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: CatFetch, child: Text('show cat')),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: DogFetch, child: Text('show dog'))
            ],
          )
        ],
      ),
    );
  }
}