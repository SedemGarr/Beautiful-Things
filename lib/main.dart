import 'dart:convert';
import 'dart:math';
import 'package:beautifulthings/auth.dart';
import 'package:beautifulthings/user.dart';
import 'package:beautifulthings/wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'globalvariables.dart';
import 'package:http/http.dart' as http;

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    lic = license;
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isdark') == null) {
      setState(() {
        isdark = false;
      });
    }

    if (prefs.getBool('isdark') == true) {
      setState(() {
        isdark = true;
      });
    }

    if (prefs.getBool('isdark') == false) {
      setState(() {
        isdark = false;
      });
    }
  }

  checkIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('introDone') == null) {
      setState(() {
        introDone = false;
      });
    }

    if (prefs.getBool('introDone') == true) {
      setState(() {
        introDone = true;
      });
    }

    if (prefs.getBool('introDone') == false) {
      setState(() {
        introDone = false;
      });
    }
  }

  getPhotosIntro() async {
    Random random = new Random();
    int randomNumber = random.nextInt(395) + 1;
    isLoading = true;
    await http
        .get(
            "http://www.splashbase.co/api/v1/images/latest?images_only=true&page=$randomNumber")
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

  @override
  void initState() {
    checkTheme();
    checkIntro();
    getPhotosIntro();
    //getPhotos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthenticationService().user,
      child: MaterialApp(
        home: SplashScreen(
            seconds: 5,
            navigateAfterSeconds: Wrapper(),
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
            loaderColor: isdark ? Colors.white : Colors.black),
      ),
    );
  }
}
