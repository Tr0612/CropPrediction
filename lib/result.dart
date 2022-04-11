import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Soil {
  final String cropName;
  const Soil({required this.cropName});

  factory Soil.fromJson(Map<String, dynamic> json) {
    return Soil(cropName: json["cropName"]);
  }
}

class ResultPage extends StatefulWidget {
  ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<Soil> jsonRes;
  @override
  void initState() {
    super.initState();
    jsonRes = getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: FutureBuilder<Soil>(
          future: jsonRes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                // setState(() {
                //   jsonRes = getData();
                // });
                return Column(
                  children: <Widget>[
                    Text(
                      "The best suitable crop for the given value would be " +
                          snapshot.data!.cropName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.pink,
                      ),
                    )
                    // Text(snapshot.data!.cropName),
                  ],
                );
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Future<Soil> getData() async {
  var url = Uri.parse("http://127.0.0.1:5000/check");
  var response = await http.get(url);
  var jsonRes;
  if (response.statusCode == 200) {
    jsonRes = jsonDecode(response.body);
    print(jsonRes);
    return Soil.fromJson(jsonRes);
  } else {
    throw Exception("Failed to load");
  }
}
