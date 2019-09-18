import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_jsonapi_demo/post.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.grey,
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Future<List<Post>> showPosts() async {
    var data = await http.get("https://jsonplaceholder.typicode.com/posts");
    var dataDecode = json.decode(data.body);

    List<Post> posts = List();
    dataDecode.forEach((post) {
      String title = post['title'];
      if (title.length > 25) {
        title = title.substring(0, 25) + "...";
      }
      String text = post['body'].replaceAll(RegExp(r'\n'), " ");
      posts.add(Post(title, text));
    });
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Json App"),
      ),
      body: FutureBuilder(
        future: showPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            snapshot.data[index].title,
                            style: TextStyle(fontSize: 25),
                          ),
                          Divider(),
                          Text(
                            snapshot.data[index].text,
                            style: TextStyle(fontSize: 15),
                          ),
                          Divider(),
                          RaisedButton(
                            child: Text("Read More..."),
                            onPressed: () {
                              Toast.show(snapshot.data[index].title, context);
                            },
                          )
                        ],
                      ),
                      // ignore: missing_return
                    ),
                  );
                });
          } else {
            return Align(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
