import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:beautifulthings/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fullimagescreen.dart';
import 'globalvariables.dart';
import 'homescreen.dart';

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('isdark', isdark);
    });
  }

  final _formKey = GlobalKey<FormState>();

  getPhotosTrending() async {
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

  @override
  void initState() {
    super.initState();
    getPhotosTrending();
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
          elevation: 0,
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
          title: IconButton(
              icon: Icon(Icons.favorite,
                  color: isdark ? Colors.white : Colors.black),
              onPressed: () {}),
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
                                  //isBy = Global.image[index].user;
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
                    // Divider(
                    //   color: isdark ? Colors.black : Colors.white,
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: isdark ? Colors.black : Colors.white),
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 16,
                    //   ),
                    //   child: Form(
                    //     key: _formKey,
                    //     child: Row(
                    //       children: [
                    //         SizedBox(
                    //           width: 0,
                    //         ),
                    //         IconButton(
                    //             icon: Icon(
                    //               Icons.info,
                    //               color: isdark ? Colors.white : Colors.black,
                    //             ),
                    //             onPressed: () {
                    //               showAboutDialog(
                    //                   context: context,
                    //                   applicationIcon: Container(
                    //                     child: Center(
                    //                       child: Image(
                    //                         image: AssetImage(
                    //                             'images/btblack.png'),
                    //                         height: 60,
                    //                         width: 60,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   applicationName: "Beautiful Things",
                    //                   applicationLegalese:
                    //                       "Developed by Sedem Garr",
                    //                   applicationVersion: "v.1.0",
                    //                   children: [
                    //                     Center(
                    //                         child: Text(
                    //                             'Beautiful Things was made using Flutter and the Pixabay API.')),
                    //                     SizedBox(
                    //                       height: 5,
                    //                     ),
                    //                     Center(
                    //                         child: Text(
                    //                             'All images are made available according to Pixabay\'s terms of use.'))
                    //                   ]);
                    //               // Navigator.push(
                    //               //     context,
                    //               //     MaterialPageRoute(
                    //               //       builder: (context) => LicensePage(),
                    //               //     ));
                    //             }),
                    //         SizedBox(
                    //           width: 20,
                    //         ),
                    //         Expanded(
                    //           child: TextFormField(
                    //             style: TextStyle(
                    //                 color:
                    //                     isdark ? Colors.white : Colors.black),
                    //             textCapitalization:
                    //                 TextCapitalization.sentences,
                    //             decoration: InputDecoration(

                    //                 // icon: Icon(
                    //                 //   Icons.search,
                    //                 //   color: Colors.grey,
                    //                 // ),
                    //                 hintText: 'Search',
                    //                 hintStyle: isdark
                    //                     ? TextStyle(color: Colors.white)
                    //                     : TextStyle(color: Colors.black)
                    //                 //fillColor: Colors.white,
                    //                 //filled: true,
                    //                 ),
                    //             validator: (val) => val.isEmpty
                    //                 ? 'Please enter a search term'
                    //                 : null,
                    //             onChanged: (val) {
                    //               setState(() => searchTerm = val.trim());
                    //             },
                    //           ),
                    //         ),
                    //         SizedBox(width: 20),
                    //         IconButton(
                    //             icon: Icon(
                    //               Icons.search,
                    //               color: isdark ? Colors.white : Colors.black,
                    //               size: 28,
                    //             ),
                    //             onPressed: () async {
                    //               if (searchTerm != null) {
                    //                 FocusScope.of(context).unfocus();
                    //                 Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (context) => SearchScreen(),
                    //                     ));
                    //                 //Navigator.of(context).pushNamed('searchscreen');
                    //               }
                    //             }),
                    //         SizedBox(width: 2)
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}
