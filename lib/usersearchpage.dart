import 'package:beautifulthings/yourprofilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globalvariables.dart';
import 'homescreen.dart';

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isdark', isdark);
    });
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
                searchTerm = null;
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => HomeScreen(),
                //     ));
                Navigator.pop(context);
              }),
          elevation: 0,
          title: Text(
            "Find People",
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
                  //  ),
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
          decoration:
              BoxDecoration(color: isdark ? Colors.black : Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Divider(color: isdark ? Colors.white : Colors.black),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                            hintText: 'Search',
                            hintStyle: isdark
                                ? TextStyle(color: Colors.white)
                                : TextStyle(color: Colors.black),
                            fillColor: isdark ? Colors.white : Colors.black,
                            //filled: true,
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Please enter a search term' : null,
                          onChanged: (val) {
                            setState(() => userNameSearch = val.trim());
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
                            if (userNameSearch != null) {
                              setState(() {
                                searching = true;
                              });

                              FocusScope.of(context).unfocus();

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => SearchScreen(),
                              //     ));
                              //Navigator.of(context).pushNamed('searchscreen');
                            }
                            if (userNameSearch == null) {
                              setState(() {
                                error = 'Please enter a username';
                              });
                            }
                          }),
                    ],
                  ),
                ),
                Divider(color: isdark ? Colors.white : Colors.black),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Results',
                  style: TextStyle(color: isdark ? Colors.white : Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: searching ? Expanded(child: SearchFeed()) : null,
                ),
                Divider(color: isdark ? Colors.white : Colors.black),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton.icon(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => YourProfilePage(),
                                ));
                          },
                          icon: Icon(
                            Icons.person,
                            color: isdark ? Colors.white : Colors.black,
                          ),
                          label: Text(
                            'Go to your profile',
                            style: TextStyle(
                                color: isdark ? Colors.white : Colors.black),
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
