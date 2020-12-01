import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';
import 'auth.dart';
import 'globalvariables.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  final databaseReference = Firestore.instance;
  bool loading = false;

  getPhotosIntro() async {
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

  @override
  void initState() {
    super.initState();
    //getPhotosIntro();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? SplashScreen(
            seconds: 5,
            //navigateAfterSeconds: Wrapper(),
            title: Text(
              'Beautiful Things',
              style: GoogleFonts.dancingScript(
                color: isdark ? Colors.white : Colors.black,
                fontSize: 40,
                fontStyle: FontStyle.italic,
                //fontWeight: FontWeight.bold,
              ),
              //TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 30.0,
              //     fontStyle: FontStyle.italic),
            ),
            image: isdark
                ? Image.asset('images/btwhite.png')
                : Image.asset('images/btblack.png'),
            backgroundColor: isdark ? Colors.black : Colors.white,
            //styleTextUnderTheLoader: TextStyle(),
            photoSize: 80.0,
            //onClick: () => print("Flutter Egypt"),
            loaderColor: isdark ? Colors.white : Colors.black)
        : Scaffold(
            //backgroundColor: Colors.pink[700],
            body: Stack(
              children: [
                GridView.builder(
                    // reverse: true,
                    itemCount: Global.image.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 0.5,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // onTap: () {
                        //   Global.Index = index;
                        //   isBy = Global.hits[index].user;
                        //   // Navigator.push(
                        //   //     context,
                        //   //     MaterialPageRoute(
                        //   //       builder: (context) => FullImageScreen(),
                        //   //     ));

                        //   Navigator.of(context)
                        //       .pushNamed('fullimagescreen');
                        // },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              // borderRadius:
                              //     BorderRadius.all(Radius.circular(10)),
                              color: Colors.transparent,
                              image: DecorationImage(
                                  image: NetworkImage(Global.image[index].url),
                                  fit: BoxFit.cover)),
                        ),
                      );
                    }),
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container(

                          //   child: Center(

                          //     child: Icon(

                          //       FontAwesomeIcons.bolt,

                          //       size: 200,

                          //       color: Colors.white,

                          //     ),

                          //   ),

                          // ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Card(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
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
                                          style: TextStyle(color: Colors.white),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            icon: Icon(
                                              Icons.email,
                                              color: Colors.white,
                                            ),

                                            hintText: 'Your Email',

                                            hintStyle:
                                                TextStyle(color: Colors.white),

                                            ////fillColor: Colors.pink[700],

                                            filled: true,

                                            // enabledBorder: OutlineInputBorder(

                                            //     borderSide: BorderSide(

                                            //         color: Colors.indigo[900], width: 2.0)),

                                            // focusedBorder: OutlineInputBorder(

                                            //     borderSide: BorderSide(

                                            //         color: Colors.indigo[900], width: 2.0)),
                                          ),
                                          validator: (val) => val.isEmpty
                                              ? 'Enter your Email'
                                              : null,
                                          onChanged: (val) {
                                            setState(() => email = val.trim());
                                          },
                                        ),
                                        SizedBox(height: 10.0),
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
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
                                              color: Colors.white,
                                            ),

                                            hintText: 'Your Username',

                                            hintStyle:
                                                TextStyle(color: Colors.white),

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
                                            setState(
                                                () => userName = val.trim());
                                          },
                                        ),
                                        SizedBox(height: 10.0),
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            icon: Icon(
                                              Icons.lock,
                                              color: Colors.white,
                                            ),

                                            hintText: 'Your Password',

                                            hintStyle:
                                                TextStyle(color: Colors.white),

                                            //fillColor: Colors.pink[700],

                                            filled: true,

                                            // enabledBorder: OutlineInputBorder(

                                            //     borderSide: BorderSide(

                                            //         color: Colors.indigo[900], width: 2.0)),

                                            // focusedBorder: OutlineInputBorder(

                                            //     borderSide: BorderSide(

                                            //         color: Colors.indigo[900], width: 2.0)),
                                          ),
                                          obscureText: true,
                                          validator: (val) => val.length < 6
                                              ? 'Your password must be at least six characters long'
                                              : null,
                                          onChanged: (val) {
                                            setState(
                                                () => password = val.trim());
                                          },
                                        ),
                                        SizedBox(height: 10.0),
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            icon: Icon(
                                              Icons.lock,
                                              color: Colors.white,
                                            ),

                                            hintText: 'Re-enter Your Password',

                                            hintStyle:
                                                TextStyle(color: Colors.white),

                                            //fillColor: Colors.pink[700],

                                            filled: true,

                                            // enabledBorder: OutlineInputBorder(

                                            //     borderSide: BorderSide(

                                            //         color: Colors.indigo[900], width: 2.0)),

                                            // focusedBorder: OutlineInputBorder(

                                            //     borderSide: BorderSide(

                                            //         color: Colors.indigo[900], width: 2.0)),
                                          ),
                                          obscureText: true,
                                          validator: (val) => val != password
                                              ? 'Passwords do not match'
                                              : null,
                                          onChanged: (val) {
                                            setState(
                                                () => password1 = val.trim());
                                          },
                                        ),
                                        SizedBox(height: 10.0),
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
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
                                              color: Colors.white,
                                            ),

                                            hintText:
                                                'A few words about yourself',

                                            hintStyle: TextStyle(
                                              color: Colors.white,
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

                                          color: Colors.white,

                                          child: Text(
                                            'Sign up',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),

                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() => loading = true);

                                              dynamic result = await _auth
                                                  .registerWithEmailAndPassword(
                                                      email, password);

                                              if (result == null) {
                                                setState(() {
                                                  loading = false;

                                                  error =
                                                      'Oops. Please check your credentials';
                                                });
                                              }
                                            }
                                          },
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          error,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'Already have an account?',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            error = " ";

                                            widget.toggleView();
                                          },
                                          child: Text('Sign in',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          );
  }
}
