import 'package:beautifulthings/wrapper.dart';
import 'package:beautifulthings/databaseservice.dart';
import 'package:beautifulthings/homescreen.dart';
import 'package:beautifulthings/yourprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'globalvariables.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
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
            "Edit your profile",
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
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: isdark ? Colors.white : Colors.black,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        color: isdark ? Colors.black : Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 50.0),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    style: TextStyle(
                                        color: isdark
                                            ? Colors.white
                                            : Colors.black),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,

                                      focusedBorder: InputBorder.none,

                                      enabledBorder: InputBorder.none,

                                      errorBorder: InputBorder.none,

                                      disabledBorder: InputBorder.none,

                                      icon: Icon(
                                        Icons.person,
                                        color: isdark
                                            ? Colors.white
                                            : Colors.black,
                                      ),

                                      hintText: 'Your Username',

                                      hintStyle: TextStyle(
                                          color: isdark
                                              ? Colors.white
                                              : Colors.black),

                                      //fillColor: Colors.pink[700],

                                      filled: true,

                                      // enabledBorder: OutlineInputBorder(

                                      //     borderSide: BorderSide(

                                      //         color: Colors.indigo[900], width: 2.0)),

                                      // focusedBorder: OutlineInputBorder(

                                      //     borderSide: BorderSide(

                                      //         color: Colors.indigo[900], width: 2.0)),
                                    ),
                                    validator: (val) => val.isEmpty
                                        ? 'Enter your Username'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => userName = val.trim());
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    style: TextStyle(
                                        color: isdark
                                            ? Colors.white
                                            : Colors.black),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    autocorrect: true,
                                    maxLines: 2,
                                    maxLength: 30,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,

                                      focusedBorder: InputBorder.none,

                                      enabledBorder: InputBorder.none,

                                      errorBorder: InputBorder.none,

                                      disabledBorder: InputBorder.none,

                                      icon: Icon(
                                        Icons.edit,
                                        color: isdark
                                            ? Colors.white
                                            : Colors.black,
                                      ),

                                      hintText: 'A few words about yourself',

                                      hintStyle: TextStyle(
                                        color: isdark
                                            ? Colors.white
                                            : Colors.black,
                                      ),

                                      //fillColor: Colors.pink[700],

                                      filled: true,

                                      // enabledBorder: OutlineInputBorder(

                                      //     borderSide: BorderSide(

                                      //         color: Colors.indigo[900], width: 2.0)),

                                      // focusedBorder: OutlineInputBorder(

                                      //     borderSide: BorderSide(

                                      //         color: Colors.indigo[900], width: 2.0)),
                                    ),
                                    validator: (val) => val.isEmpty
                                        ? 'A few words about yourself'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => about = val.trim());
                                    },
                                  ),
                                  SizedBox(height: 10.0),
                                  FlatButton(
                                    // elevation: 4,

                                    color: isdark ? Colors.white : Colors.black,

                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color: isdark
                                              ? Colors.black
                                              : Colors.white),
                                    ),

                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        DatabaseService()
                                            .editUserData(userName, about);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Wrapper(),
                                            ));
                                      }
                                    },
                                  ),
                                  SizedBox(height: 10.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
