import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search;
  int offset = 0;
  Future<Map> getGifs() async {
    http.Response response;
    if (search == null || search.isEmpty) {
      response = await http.get(
          //"https://api.giphy.com/v1/gifs/trending?api_key=JAdY4yUPPgka83J2B4ZSUGfaxfyD9qZG&limit=25&rating=G");

          "https://api.giphy.com/v1/gifs/trending?api_key=JAdY4yUPPgka83J2B4ZSUGfaxfyD9qZG&limit=30&rating=G");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=JAdY4yUPPgka83J2B4ZSUGfaxfyD9qZG&q=$search&limit=19&offset=$offset&rating=G&lang=en");
      return json.decode(response.body);
    }
    @override
    void initState() async {
      super.initState();
      getGifs().then((map) {
        print(map);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int getCount(List data) {
    if (search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: getCount(snapshot.data['data']),
        itemBuilder: (context, index) {
          if (search == null || index < snapshot.data['data'].length)
            return GestureDetector(
              child: Image.network(
                snapshot.data['data'][index]["images"]["fixed_height"]["url"],
                height: 300,
                fit: BoxFit.cover,
              ),
            );
          else {
            return Container(
              child:GestureDetector(child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70),
                    Text(
                      "Carregar mais",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
                
                onTap: () {
                  setState(() {
                    offset +=19;
                  });
                }),);
          } 
        });
  }
}
