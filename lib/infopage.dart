import 'package:flutter/material.dart';
import 'globalvariables.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: isdark
            ? ThemeData(
                //primarySwatch: Colors.blue,
                primaryColor: Colors.black,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              )
            : ThemeData(
                //primarySwatch: Colors.red,
                primaryColor: Colors.white,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Beautiful Things'),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(children: [
              SizedBox(height: 20),
              Center(
                child: Text('Built with Flutter and the Pixabay API'),
              ),
              Divider(),
              Center(
                child: Text(lic),
              ),
            ]),
          ),
        ));
  }
}
