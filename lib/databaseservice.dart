import 'package:cloud_firestore/cloud_firestore.dart';

import 'globalvariables.dart';

class DatabaseService {
  final CollectionReference photosCollection =
      Firestore.instance.collection('User Data');

  Future updateUserData(String userName, String idUser, List isFollowing,
      String about, String dP) async {
    return await photosCollection.document(idUser).setData({
      "User Name": userName,
      "UID": idUser,
      "is following": isFollowing,
      "about": about,
      "DP": dP
    });
  }

  Future editUserData(String userName, String about) async {
    return await photosCollection.document(idUser).setData({
      "User Name": userName,
      "about": about,
    }, merge: true);
  }

  Future editDP(String dP) async {
    return await photosCollection.document(idUser).setData({
      "DP": dP,
    }, merge: true);
  }
}
