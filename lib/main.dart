import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './detailspage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List data;

  @override
  void initState() {
    super.initState();
    fetch_data_from_api();
  }

  Future<String> fetch_data_from_api() async {
    var jsondata = await http.get("https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=1ce7b58cc24543e7acdd2433bbd271d6");
    var fetchdata = jsonDecode(jsondata.body);
    setState(() {
      data = fetchdata["articles"];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "News App",
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        home: Scaffold(
          backgroundColor: Colors.black,
            appBar: AppBar(
              centerTitle: true,
              title:Row(
                children: <Widget>[
                  Container(
                    child: Text("News"),
                  ),
                  SizedBox(width: 3.0,),
                  Container(
                    child: Text("Mod",style: TextStyle(color: Colors.blueAccent),),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 90.0),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                    author: data[index]["author"],
                                    title: data[index]["title"],
                                    description: data[index]["description"],
                                    urlToImage: data[index]["urlToImage"],
                                    publishedAt: data[index]["publishedAt"],
                                  )));
                    },
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35.0),
                              topRight: Radius.circular(35.0),
                            ),
                            child: Image.network(
                              data[index]["urlToImage"],
                              fit: BoxFit.cover,
                              height: 400.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 350.0, 0.0, 0.0),
                          child: Container(
                            height: 200.0,
                            width: 400.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(35.0),
                              elevation: 10.0,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 10.0, 20.0),
                                    child: Text(
                                      data[index]["title"],
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: data == null ? 0 : data.length,
                autoplay: true,
                viewportFraction: 0.8,
                scale: 0.9,
              ),
            )));
  }
}
