import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(CurrencyApp());
}

class CurrencyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency APP',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: CurrencyAppPage(),
    );
  }
}

class CurrencyAppPage extends StatefulWidget {
  CurrencyAppPageState createState() => CurrencyAppPageState();
}

class CurrencyAppPageState extends State<CurrencyAppPage> {
  final apiKey = 'a9305bd1eaab820a662ca9a6';
  final baseUrl = 'https://v6.exchangerate-api.com/v6';
  TextEditingController controller = TextEditingController();

  String from = 'usd';
  String to = 'inr';
  double ? result;

  Future<void> Cu_rrency() async {
    final amount = controller.text;
    if (amount.isEmpty) return;
    final url = '$baseUrl/$apiKey/pair/$from/$to/${controller.text}';
    final responses = await http.get(Uri.parse(url));
    if (responses.statusCode == 200) {
      final data = jsonDecode(responses.body);
      setState(() {
        result = data['conversion_result'];
      });
    }
    else {
      print('failed to fetch exchange rate');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'amount'
              ),
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                Expanded(child: DropdownButton<String>(
                  value: from,
                  items: ['usd', 'inr', 'eur', 'jpy', 'gbp']
                      .map((code) =>
                      DropdownMenuItem(child: Text(code),
                        value: code,
                      ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      from = value!;
                    });
                  },
                ),
                ),
                Icon(Icons.arrow_forward),
                Expanded(
                  child: DropdownButton<String>(
                    value: to,
                    isExpanded: true,
                    items: ['usd', 'inr', 'eur', 'jpy', 'gbp']
                        .map((code) =>
                        DropdownMenuItem(
                          child: Text(code),
                          value: code,))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        to = value!;
                      });
                    },
                  ),

                ),
              ],
            ),
            ElevatedButton(onPressed: Cu_rrency, child: Text('convert'),
            ),
            SizedBox(
              height: 20,
            ),
            if(result != null)Text(
                'Result:$result', style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}