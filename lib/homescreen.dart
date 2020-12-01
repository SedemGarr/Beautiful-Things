import 'dart:convert';
import 'package:beautifulthings/auth.dart';
import 'package:beautifulthings/trendingpage.dart';
import 'package:beautifulthings/usersearchpage.dart';
import 'package:beautifulthings/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:beautifulthings/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fullimagescreen.dart';
import 'fullimagescreen2.dart';
import 'globalvariables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isdark', isdark);
    });
  }

  final _formKey = GlobalKey<FormState>();
  final AuthenticationService _auth = AuthenticationService();

  getPhotos() async {
    isLoading = true;
    await http
        .get("http://www.splashbase.co/api/v1/images/latest?images_only=true")
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

  Future getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idUser = prefs.getString('Firebase ID') ?? '';
    print(idUser);
  }

  @override
  void initState() {
    super.initState();
    getPhotos();
    getUID();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'fullimagescreen': (context) => FullImageScreen(),
        'searchscreen': (context) => SearchScreen()
      },
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
              icon: Icon(Icons.time_to_leave),
              onPressed: () async {
                await _auth.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Wrapper(),
                    ));
              }),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(Icons.home,
                      color: isdark ? Colors.white : Colors.black),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.favorite,
                      color: isdark ? Colors.white : Colors.black),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrendingPage(),
                        ));
                  }),
            ],
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 5, top: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Switch(
                      value: isdark,
                      onChanged: (value) {
                        setState(() {
                          isdark = value;
                          //isdark = false;
                          print(isdark);
                        });
                        saveTheme();
                      },
                      activeTrackColor: Colors.white70,
                      activeColor: Colors.white,
                      inactiveThumbColor: Colors.black87,
                      inactiveTrackColor: Colors.grey,
                    ),
                  ),
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
        body: Container(
          decoration: BoxDecoration(
            color: isdark ? Colors.black : Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('User Posts')
                          .document('Posts')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          var userDocument1 = snapshot.data;

                          List userDocument3 =
                              userDocument1['userposts'].toList();
                          List userDocument4 = [];
                          userDocument3.forEach((element) {
                            if (element['is Following'].contains(idUser)) {
                              userDocument4.add(element);
                            }
                          });
                          var userDocument5 = userDocument4.reversed.toList();
                          print(userDocument3);

                          return GridView.builder(
                              // reverse: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.5,
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 5),
                              itemBuilder: (context, index) {
                                try {
                                  return GestureDetector(
                                    onTap: () {
                                      imageFromProfileScreen =
                                          userDocument5[index]['largeURL']
                                              .toString();
                                      imageFromProfileScreenSmall =
                                          userDocument5[index]['smallURL']
                                              .toString();
                                      photoIDFromProfileScreen =
                                          userDocument5[index]['photoID']
                                              .toString();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FullImageScreen2(),
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.transparent,
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            userDocument5[index]['createdBy'],
                                            style: GoogleFonts.dancingScript(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: isdark
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: Image(
                                                  image: NetworkImage(
                                                      userDocument5[index]
                                                              ['smallURL']
                                                          .toString()),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor:
                                          isdark ? Colors.black : Colors.white,
                                      valueColor: isdark
                                          ? AlwaysStoppedAnimation<Color>(
                                              Colors.white)
                                          : AlwaysStoppedAnimation<Color>(
                                              Colors.black),
                                    ),
                                  );
                                }
                              },
                              // separatorBuilder: (context, index) => Divider(
                              //       color: Colors.pink[700],
                              //     ),
                              itemCount: userDocument4.length);
                        } else {
                          return Center(
                            child: Container(
                              child: CircularProgressIndicator(
                                backgroundColor:
                                    isdark ? Colors.black : Colors.white,
                                valueColor: isdark
                                    ? AlwaysStoppedAnimation<Color>(
                                        Colors.white)
                                    : AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ),
              // Divider(
              //   color: isdark ? Colors.black : Colors.white,
              // ),
              Container(
                decoration:
                    BoxDecoration(color: isdark ? Colors.black : Colors.white),
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 0,
                      ),
                      // IconButton(
                      //     icon: Icon(
                      //       Icons.info,
                      //       color: isdark ? Colors.white : Colors.black,
                      //     ),
                      //     onPressed: () {
                      //       showAboutDialog(
                      //           context: context,
                      //           applicationIcon: Container(
                      //             child: Center(
                      //               child: Image(
                      //                 image: AssetImage(
                      //                     'images/btblack.png'),
                      //                 height: 60,
                      //                 width: 60,
                      //               ),
                      //             ),
                      //           ),
                      //           applicationName: "Beautiful Things",
                      //           applicationLegalese:
                      //               "Developed by Sedem Garr",
                      //           applicationVersion: "v.1.0",
                      //           children: [
                      //             Center(
                      //                 child: Text(
                      //                     'Beautiful Things was made using Flutter and the SplahBase API.')),
                      //             SizedBox(
                      //               height: 5,
                      //             ),
                      //             Center(
                      //                 child: Text(
                      //                     'All images are made available according to SplashBase\'s terms of use.'))
                      //           ]);
                      //       // Navigator.push(
                      //       //     context,
                      //       //     MaterialPageRoute(
                      //       //       builder: (context) => LicensePage(),
                      //       //     ));
                      //     }),
                      IconButton(
                          icon: Icon(
                            Icons.person_add,
                            color: isdark ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserSearchPage(),
                                ));
                          }),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(
                              color: isdark ? Colors.white : Colors.black),
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,

                              // icon: Icon(
                              //   Icons.search,
                              //   color: Colors.grey,
                              // ),
                              hintText: 'Search for pictures',
                              hintStyle: isdark
                                  ? TextStyle(color: Colors.white)
                                  : TextStyle(color: Colors.black)
                              //fillColor: Colors.white,
                              //filled: true,
                              ),
                          validator: (val) =>
                              val.isEmpty ? 'Please enter a search term' : null,
                          onChanged: (val) {
                            setState(() => searchTerm = val.trim());
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                          icon: Icon(
                            Icons.search,
                            color: isdark ? Colors.white : Colors.black,
                            size: 28,
                          ),
                          onPressed: () async {
                            if (searchTerm != null) {
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchScreen(),
                                  ));
                              //Navigator.of(context).pushNamed('searchscreen');
                            }
                          }),
                      SizedBox(width: 2)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
