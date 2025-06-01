import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(QuotesApp());
}

class QuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: QuotesAppPage(),
    );
  }
}

class QuotesAppPage extends StatefulWidget {
  @override
  QuotesAppPageState createState() => QuotesAppPageState();
}

class QuotesAppPageState extends State<QuotesAppPage> {
  String quote = '';
  String author = '';
  bool isLoading = false;

  Future<void> fetchQuote() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://api.quotable.io/random');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          quote = data['content'];
          author = data['author'];
        });
      } else {
        setState(() {
          quote = 'Failed to load quote';
          author = '';
        });
      }
    } catch (e) {
      setState(() {
        quote = 'Something went wrong';
        author = '';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                quote,
                style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                author,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: fetchQuote,
                child: const Text('Get New Quote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
