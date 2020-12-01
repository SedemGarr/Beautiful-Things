import 'package:beautifulthings/editprofilepage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fullimagescreen2.dart';
import 'globalvariables.dart';

class YourProfilePage extends StatefulWidget {
  @override
  _YourProfilePageState createState() => _YourProfilePageState();
}

class _YourProfilePageState extends State<YourProfilePage> {
  List mon;
  List mon1;

  saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isdark', isdark);
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

  // followingCheck() async {
  //   docRef = Firestore.instance.collection('User Data').document(searchId);
  //   DocumentSnapshot doc = await docRef.get();
  //   List tags = doc.data['is following'];
  //   if (tags.contains(idUser) == true) {
  //     setState(() {
  //       alreadyFollowing = true;
  //     });
  //   } else {
  //     setState(() {
  //       alreadyFollowing = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getUserData();
    // followingCheck();
  }

  // void showLongToast() {
  //   Fluttertoast.showToast(
  //     msg: "New posts from $searchName will show up in your feed",
  //     toastLength: Toast.LENGTH_LONG,
  //   );
  // }

  // void showLongToast1() {
  //   Fluttertoast.showToast(
  //     msg: "New posts from $searchName will no longer show up in your feed",
  //     toastLength: Toast.LENGTH_LONG,
  //   );
  // }

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
              createdby,
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
                padding: EdgeInsets.only(right: 5, top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: isdark ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(),
                              ));
                        })
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
          body: Column(children: [
            Container(
              decoration: BoxDecoration(
                color: isdark ? Colors.black : Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        isFollowingPost.length.toString(),
                        style: TextStyle(
                            color: isdark ? Colors.white : Colors.black,
                            fontSize: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(dP) ?? null,
                        backgroundColor: isdark ? Colors.white : Colors.black,
                        foregroundColor: isdark ? Colors.white : Colors.black,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container()
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(about,
                          style: TextStyle(
                              color: isdark ? Colors.white : Colors.black)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'You are viewing your profile',
                    style:
                        TextStyle(color: isdark ? Colors.white : Colors.black),
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
                            if (element['uid'].contains(idUser)) {
                              userDocument4.add(element);
                            }
                          });

                          print(userDocument3);

                          return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5),
                              itemBuilder: (context, index) {
                                try {
                                  return GestureDetector(
                                    onTap: () {
                                      imageFromProfileScreen =
                                          userDocument4[index]['largeURL']
                                              .toString();
                                      imageFromProfileScreenSmall =
                                          userDocument4[index]['smallURL']
                                              .toString();
                                      photoIDFromProfileScreen =
                                          userDocument4[index]['photoID']
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
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  userDocument4[index]
                                                          ['smallURL']
                                                      .toString()),
                                              fit: BoxFit.cover)),
                                    ),
                                  );
                                } catch (e) {
                                  return Container();
                                }
                              },
                              // separatorBuilder: (context, index) => Divider(
                              //       color: Colors.pink[700],
                              //     ),
                              itemCount: userDocument4.length);
                        } else {
                          return Container();
                        }
                      }),
                ),
              ),
            ),
          ]),
        ));
  }
}
