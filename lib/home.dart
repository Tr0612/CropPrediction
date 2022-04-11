import 'dart:convert';

import 'package:farmapp/result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  var url = Uri.parse("http://127.0.0.1:5000/putdata");
  Properties prop = Properties(
      nitrogen: 0,
      phosporus: 0,
      temperature: 0,
      humidity: 0,
      ph: 0,
      potassium: 0,
      rainfall: 0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _Nitrogen = TextEditingController();
  final _Phosporus = TextEditingController();
  final _Temperature = TextEditingController();
  final _Humidity = TextEditingController();
  final _Rainfall = TextEditingController();
  final _pH = TextEditingController();
  final _Potassium = TextEditingController();
  @override
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.gps_fixed),
      ),
      appBar: AppBar(
        title: Text("Farm App"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  field("Nitrogen", _Nitrogen),
                  field("Phosporus", _Phosporus),
                  field("Potassium", _Potassium),
                  field("Temperature", _Temperature),
                  field("Humidity", _Humidity),
                  field("pH", _pH),
                  field("Rainfall", _Rainfall),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print(prop.humidity);
                        var response = await http.post(
                          url,
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(
                            {
                              "Humidity": prop.humidity,
                              "Nitrogen": prop.nitrogen,
                              "Phosphorous": prop.phosporus,
                              "Potassium": prop.potassium,
                              "Rainfall": prop.rainfall,
                              "Temperature": prop.temperature.toString(),
                              "pH": prop.ph
                            },
                          ),
                        );
                        print(response.body);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultPage(),
                          ),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField field(
    String text,
    TextEditingController name,
  ) {
    return TextFormField(
      controller: name,
      decoration: InputDecoration(hintText: text),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Enter some text";
        }
        return null;
      },
      onSaved: (value) {
        if (text == "Nitrogen") prop.nitrogen = int.parse(value.toString());

        if (text == "Phosporus") prop.phosporus = int.parse(value.toString());

        if (text == "Temperature")
          prop.temperature = int.parse(value.toString());

        if (text == "Humidity") prop.humidity = int.parse(value.toString());
        if (text == "Potassium") prop.potassium = int.parse(value.toString());
        if (text == "Rainfall") prop.rainfall = int.parse(value.toString());
        if (text == "pH") prop.ph = int.parse(value.toString());
      },
    );
  }
}

class Properties {
  int? nitrogen;
  int? phosporus;
  int? temperature;
  int? humidity;
  int? rainfall;
  int? ph;
  int? potassium;

  Properties({
    required this.nitrogen,
    required this.phosporus,
    required this.temperature,
    required this.humidity,
    required this.ph,
    required this.potassium,
    required this.rainfall,
  });
}
