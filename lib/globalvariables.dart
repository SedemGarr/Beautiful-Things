import 'package:beautifulthings/fullimagescreen2.dart';
import 'package:beautifulthings/profilepage.dart';
import 'package:beautifulthings/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String searchDP;
String imageFromProfileScreen;
String imageFromProfileScreenSmall;
String photoIDFromProfileScreen;
bool introDone = false;
bool isdark = true;
String searchTerm;
bool isLoading = true;
String isBy;
String lic;
var idUser;
bool loading = false;
String error = ' ';
String email;
String password;
String password1;
String userName;
double opacityValue = 0.50;
String userSearchTerm;
String about;
List isFollowing = [idUser];
String userNameSearch;
String idUserSearch;
bool searching = false;
bool alreadyFollowing = false;
bool showFOUF = false;
String idUser1;
DocumentReference docRef;
String searchId;
String searchName;
String searchAbout;
var photoID;
String photoWebURL;
String photoLargeURL;
DateTime createdOn = DateTime.now();
String createdby;
List isFollowingPost;
String isBy2;
String dP;
var searchFollowing;

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

class Global {
  static List<Images> image = new List();
  static int Index = 0;
}

class Images {
  int id;
  String url;
  String largeUrl;
  int sourceId;

  Images({this.id, this.url, this.largeUrl, this.sourceId});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    largeUrl = json['large_url'];
    sourceId = json['source_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['large_url'] = this.largeUrl;
    data['source_id'] = this.sourceId;
    return data;
  }
}

class SearchFeed extends StatefulWidget {
  @override
  _SearchFeedState createState() => _SearchFeedState();
}

class _SearchFeedState extends State<SearchFeed> {
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
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('User Data')
            .where('User Name', isEqualTo: userNameSearch)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                if (snapshot.hasData) {
                  try {
                    return ListTile(
                      onTap: () async {
                        searchFollowing =
                            snapshot.data.documents[index]['is following'];
                        searchId = snapshot.data.documents[index]['UID'];
                        searchName =
                            snapshot.data.documents[index]['User Name'];
                        searchAbout = snapshot.data.documents[index]['about'];
                        searchDP = snapshot.data.documents[index]['DP'];
                        setState(() {
                          followingCheck();
                        });
                        print(snapshot.data.documents[index]['UID']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ));
                      },
                      title: Text(
                        snapshot.data.documents[index]['User Name'] == null
                            ? ''
                            : snapshot.data.documents[index]['User Name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isdark ? Colors.white : Colors.black),
                      ),
                      subtitle: Text(
                        snapshot.data.documents[index]['about'] == null
                            ? ''
                            : snapshot.data.documents[index]['about'],
                        style: TextStyle(
                            color: isdark ? Colors.white : Colors.black),
                      ),
                    );
                  } catch (e) {
                    print(e.toString());
                  }
                } else {
                  return Container();
                }
              });
        });
  }
}

class IntroWidget extends StatefulWidget {
  @override
  _IntroWidgetState createState() => _IntroWidgetState();
}

class _IntroWidgetState extends State<IntroWidget> {
  saveIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('introDone', introDone);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Container(
          decoration:
              BoxDecoration(color: isdark ? Colors.black : Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text('Welcome to Beautiful Things',
                    style: TextStyle(
                        fontSize: 25,
                        color: isdark ? Colors.white : Colors.black)),
              ),
              SizedBox(height: 10),
              Center(
                child: Text('Here are a few tips to help you get started',
                    style:
                        TextStyle(color: isdark ? Colors.white : Colors.black)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 40),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.home,
                          color: isdark ? Colors.white : Colors.black),
                      title: Text('Home',
                          style: TextStyle(
                              color: isdark ? Colors.white : Colors.black)),
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite,
                          color: isdark ? Colors.white : Colors.black),
                      title: Text('Trending',
                          style: TextStyle(
                              color: isdark ? Colors.white : Colors.black)),
                    ),
                    ListTile(
                      leading: Icon(Icons.person_add,
                          color: isdark ? Colors.white : Colors.black),
                      title: Text('Search for people',
                          style: TextStyle(
                              color: isdark ? Colors.white : Colors.black)),
                    ),
                    ListTile(
                      leading: Icon(Icons.search,
                          color: isdark ? Colors.white : Colors.black),
                      title: Text('Search for pictures',
                          style: TextStyle(
                              color: isdark ? Colors.white : Colors.black)),
                    ),
                    ListTile(
                      leading: Icon(Icons.time_to_leave,
                          color: isdark ? Colors.white : Colors.black),
                      title: Text('Sign out',
                          style: TextStyle(
                              color: isdark ? Colors.white : Colors.black)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              FlatButton.icon(
                  onPressed: () async {
                    setState(() {
                      introDone = true;
                      saveIntro();
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Wrapper(),
                        ));
                  },
                  icon: Icon(Icons.thumb_up,
                      color: isdark ? Colors.white : Colors.black),
                  label: Text('Got it?',
                      style: TextStyle(
                          color: isdark ? Colors.white : Colors.black)))
            ],
          ),
        ),
      ),
    ));
  }
}

class ProfileFeed extends StatefulWidget {
  @override
  _ProfileFeedState createState() => _ProfileFeedState();
}

class _ProfileFeedState extends State<ProfileFeed> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('User Posts')
              .document('Posts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              var userDocument1 = snapshot.data;

              List userDocument3 = userDocument1['userposts'].toList();
              List userDocument4 = [];
              userDocument3.forEach((element) {
                if (element['uid'].contains(searchId)) {
                  userDocument4.add(element);
                }
              });

              print(userDocument3);

              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    try {
                      return GestureDetector(
                        onTap: () {
                          imageFromProfileScreen =
                              userDocument4[index]['largeURL'].toString();
                          imageFromProfileScreenSmall =
                              userDocument4[index]['smallURL'].toString();
                          photoIDFromProfileScreen =
                              userDocument4[index]['photoID'].toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullImageScreen2(),
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.transparent,
                              image: DecorationImage(
                                  image: NetworkImage(userDocument4[index]
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
    );
  }
}

class FollowButton extends StatefulWidget {
  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return alreadyFollowing
        ? IconButton(
            icon: Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () async {
              setState(() {
                docRef.updateData({
                  'is following': FieldValue.arrayRemove([idUser])
                });
              });
              setState(() {
                alreadyFollowing = false;
              });
            })
        : IconButton(
            icon: Icon(Icons.add_circle, color: Colors.green),
            onPressed: () async {
              setState(() {
                docRef.updateData({
                  'is following': FieldValue.arrayUnion([idUser])
                });
              });
              setState(() {
                alreadyFollowing = true;
              });
            });
  }
}
