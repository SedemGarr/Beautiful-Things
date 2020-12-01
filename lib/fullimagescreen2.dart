import 'package:beautifulthings/databaseservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth.dart';
import 'globalvariables.dart';

class FullImageScreen2 extends StatefulWidget {
  @override
  _FullImageScreen2State createState() => _FullImageScreen2State();
}

class _FullImageScreen2State extends State<FullImageScreen2> {
  PageController pageController = new PageController(initialPage: Global.Index);

  saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isdark', isdark);
    });
  }

  Future getdatacheck() async {
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

  void showLongToast2() {
    Fluttertoast.showToast(
      msg: "This photo has been set as your profile picture",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  void initState() {
    getdatacheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          // Switch(
          //   value: isdark,
          //   onChanged: (value) {
          //     setState(() {
          //       isdark = value;
          //       //isdark = false;
          //       print(isdark);
          //     });
          //     saveTheme();
          //   },
          //   activeTrackColor: Colors.white70,
          //   activeColor: Colors.white,
          //   inactiveThumbColor: Colors.black87,
          //   inactiveTrackColor: Colors.grey,
          // ),
        ],
        backgroundColor: isdark ? Colors.black : Colors.white,
        elevation: 0,
        // title: Text(
        //   "Photo by $isBy2",
        //   style: GoogleFonts.dancingScript(
        //     //color: isdark ? Colors.white : Colors.black,
        //     fontSize: 20,
        //     //fontStyle: FontStyle.italic,
        //     //fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isdark ? Colors.black : Colors.white,
        ),
        child: PageView.builder(
            controller: pageController,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => launch(imageFromProfileScreen),
                      child: Container(
                          decoration: BoxDecoration(
                        color: isdark ? Colors.black : Colors.white,
                        image: DecorationImage(
                            image: NetworkImage(imageFromProfileScreen)),
                        //fit: BoxFit.cover
                      )),
                    ),
                  ),

                  // SizedBox(
                  //   height: 5,
                  // ),
                  // InkWell(
                  //     child: Text('from Pixabay'),
                  //     onTap: () => launch('https://pixabay.com/')),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Divider(color: isdark ? Colors.white : Colors.black),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton.icon(
                            onPressed: () async {
                              Map postArray = {
                                'photoID': photoIDFromProfileScreen,
                                //'isby': Global.hits[index].user,
                                'createdOn': DateTime.now(),
                                'createdBy': createdby,
                                'is Following': isFollowingPost,
                                'uid': idUser,
                                'smallURL': imageFromProfileScreenSmall,
                                'largeURL': imageFromProfileScreen
                              };
                              return await Firestore.instance
                                  .collection('User Posts')
                                  .document('Posts')
                                  .updateData({
                                "userposts": FieldValue.arrayUnion([postArray])
                              }).then((value) => Navigator.pop(context));

                              // cleanData();

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => Wrapper(),
                              //     ));
                            },
                            icon: Icon(
                              Icons.mobile_screen_share,
                              color: isdark ? Colors.white : Colors.black,
                            ),
                            label: Text(
                              'Share',
                              style: TextStyle(
                                  color: isdark ? Colors.white : Colors.black),
                            )),
                        // Divider(),
                        FlatButton.icon(
                            onPressed: () async {
                              dP = imageFromProfileScreenSmall;
                              showLongToast2();
                              DatabaseService().editDP(dP);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => Wrapper(),
                              //     ));
                            },
                            icon: Icon(
                              Icons.add_photo_alternate,
                              color: isdark ? Colors.white : Colors.black,
                            ),
                            label: Text(
                              'Set as profile picture',
                              style: TextStyle(
                                  color: isdark ? Colors.white : Colors.black),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 10)
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: isdark ? Colors.black : Colors.white,
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             'Photo by ' + Global.hits[index].user,
                  //             style: TextStyle(
                  //                 color: isdark ? Colors.white : Colors.black),
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(height: 5)
                  //     ],
                  //   ),
                  // ),
                ],
              );
            }),
      ),
    );
  }
}
