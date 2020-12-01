import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fullimagescreen.dart';
import 'globalvariables.dart';
import 'package:http/http.dart' as http;

import 'homescreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isdark', isdark);
    });
  }

  getPhotosBySearch() async {
    isLoading = true;
    await http
        .get("http://www.splashbase.co/api/v1/images/search?query=$searchTerm")
        .then((res) {
      print(res.body);

      var parsedData = jsonDecode(res.body);
      Global.image = (parsedData["images"] as List)
          .map((data) => Images.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    });
  }

  Future getUserData() async {
    Firestore.instance
        .collection("User Data")
        .document(idUser)
        .get()
        .then((value) {
      createdby = value.data['User Name'];
      isFollowingPost = value.data['is following'];
      about = value.data['about'];
      dP = value.data['DP'];
      print(value.data);
    });
  }

  @override
  void initState() {
    super.initState();
    getPhotosBySearch();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'fullimagescreen': (context) => FullImageScreen()},
      title: 'Beautiful Things',
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
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                searchTerm = null;
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => HomeScreen(),
                //     ));
                isLoading = false;
                Navigator.pop(context);
              }),
          elevation: 0,
          title: Text(
            "\"$searchTerm\"",
            style: GoogleFonts.dancingScript(
              //color: isdark ? Colors.white : Colors.black,
              fontSize: 28,
              //fontStyle: FontStyle.italic,
              //fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 5, top: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Expanded(
                  //   child: Switch(
                  //     value: isdark,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         isdark = value;
                  //         //isdark = false;
                  //         print(isdark);
                  //       });
                  //       saveTheme();
                  //     },
                  //     activeTrackColor: Colors.white70,
                  //     activeColor: Colors.white,
                  //     inactiveThumbColor: Colors.black87,
                  //     inactiveTrackColor: Colors.grey,
                  //   ),
                  // ),
                  // Expanded(
                  //     child: isdark
                  //         ? Text(
                  //             'Light',
                  //             style: TextStyle(fontSize: 10),
                  //           )
                  //         : Text(
                  //             'Dark',
                  //             style: TextStyle(fontSize: 10),
                  //           ))
                ],
              ),
            )
          ],
        ),
        body: isLoading
            ? Center(
                child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: isdark ? Colors.black : Colors.white,
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: isdark ? Colors.black : Colors.white,
                    valueColor: isdark
                        ? AlwaysStoppedAnimation<Color>(Colors.white)
                        : AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              ))
            : Container(
                decoration: BoxDecoration(
                  color: isdark ? Colors.black : Colors.white,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            itemCount: Global.image.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.5,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Global.Index = index;
                                  //isBy2 = Global.hits[index].user;
                                  getUserData();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => FullImageScreen(),
                                  //     ));
                                  Navigator.of(context)
                                      .pushNamed('fullimagescreen');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              Global.image[index].url),
                                          fit: BoxFit.cover)),
                                ),
                              );
                            }),
                      ),
                    ),
                    SizedBox(height: 10)
                  ],
                ),
              ),
      ),
    );
  }
}
