import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globalvariables.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List mon;
  List mon1;

  saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isdark', isdark);
    });
  }

  rfd() {
    setState(() {
      var x = 1;
    });
  }

  followingCheck() async {
    docRef = Firestore.instance.collection('User Data').document(searchId);
    DocumentSnapshot doc = await docRef.get();
    List tags = doc.data['is following'];
    if (tags.contains(idUser) == true) {
      setState(() {
        alreadyFollowing = true;
      });
    } else {
      setState(() {
        alreadyFollowing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    rfd();
    followingCheck();
  }

  void showLongToast() {
    Fluttertoast.showToast(
      msg: "New posts from $searchName will show up in your feed",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void showLongToast1() {
    Fluttertoast.showToast(
      msg: "New posts from $searchName will no longer show up in your feed",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                  userNameSearch = null;
                  searching = false;
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => UserSearchPage(),
                  //     ));
                  Navigator.pop(context);
                }),
            elevation: 0,
            title: Text(
              searchName,
              style: GoogleFonts.dancingScript(
                color: isdark ? Colors.white : Colors.black,
                fontSize: 28,
                //fontStyle: FontStyle.italic,
                //fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Text(
                    searchFollowing.length.toString(),
                    style: TextStyle(
                        color: isdark ? Colors.white : Colors.black,
                        fontSize: 20),
                  ),
                ),
              )
            ],
          ),
          body: Column(children: [
            Container(
              decoration: BoxDecoration(
                color: isdark ? Colors.black : Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //SizedBox(width: 20),
                      CircleAvatar(
                        backgroundImage: NetworkImage(searchDP) ?? null,
                        backgroundColor: isdark ? Colors.white : Colors.black,
                        foregroundColor: isdark ? Colors.white : Colors.black,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      idUser == searchId
                          ? Container()
                          : alreadyFollowing
                              ? IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () async {
                                    showLongToast1();
                                    setState(() {
                                      docRef.updateData({
                                        'is following':
                                            FieldValue.arrayRemove([idUser])
                                      });
                                    });
                                    setState(() {
                                      alreadyFollowing = false;
                                    });
                                  })
                              : IconButton(
                                  icon: Icon(Icons.add_circle,
                                      color: Colors.green),
                                  onPressed: () async {
                                    showLongToast();
                                    setState(() {
                                      docRef.updateData({
                                        'is following':
                                            FieldValue.arrayUnion([idUser])
                                      });
                                    });
                                    setState(() {
                                      alreadyFollowing = true;
                                    });
                                  })
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(searchAbout,
                          style: TextStyle(
                              color: isdark ? Colors.white : Colors.black)),
                    ],
                  ),
                  SizedBox(height: 10),
                  idUser == searchId
                      ? Text(
                          'You are viewing your profile',
                          style: TextStyle(
                              color: isdark ? Colors.white : Colors.black),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            alreadyFollowing
                                ? Text('You are following $searchName',
                                    style: TextStyle(
                                        color: isdark
                                            ? Colors.green
                                            : Colors.green))
                                : Text('You are not following $searchName',
                                    style: TextStyle(
                                        color:
                                            isdark ? Colors.red : Colors.red))
                          ],
                        ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            // Divider(
            //   color: isdark ? Colors.white : Colors.black,
            // ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isdark ? Colors.white : Colors.black,
                ),
                child: ProfileFeed(),
              ),
            ),
          ]),
        ));
  }
}
