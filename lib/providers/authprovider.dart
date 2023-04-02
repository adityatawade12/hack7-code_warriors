import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

class LoggedInUser {
  final String name;
  final String vpa;
  final String primaryAccountSol;
  final String primaryAccountEth;

  LoggedInUser(
      this.name, this.vpa, this.primaryAccountSol, this.primaryAccountEth);
}

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = "";
  String primaryAddress = "";
  LoggedInUser loggedInUser = LoggedInUser('', '', '', '');

  Future signIn(String email, String password) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // uid = user.user!.uid;
      // var db = FirebaseFirestore.instance;
      // var userData = await db.collection('users').doc(user.user!.uid).get();
      // var data = userData.data();
      // primaryAddress = userData.data()!['vpa'];
      // loggedInUser =
      //     LoggedInUser(data!['name'], data['vpa'], data['primaryAccount']);
      if (user == null) {
        return null;
      }
      getUserData();
      notifyListeners();
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getUserData() async {
    uid = _auth.currentUser!.uid;
    var db = FirebaseFirestore.instance;
    var userData = await db.collection('users').doc(uid).get();
    var data = userData.data();
    primaryAddress = userData.data()!['vpa'];
    loggedInUser = LoggedInUser(data!['name'], data['vpa'],
        data['primaryAccountSol'], data['primaryAccountEth']);
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcm token");
    var token = await Pushy.getDeviceCredentials() as Map;
    db
        .collection('users')
        .doc(currentUser!.uid)
        .update({"notifId": token["token"]});
    print(token);
  }

  Future signUp(String name, String email, String password, String vpa) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var token = await Pushy.getDeviceCredentials() as Map;

      final userDb = <String, dynamic>{
        "name": name,
        "vpa": vpa,
        "primaryAccountSol": "",
        "primaryAccountEth": "",
        "sol": [],
        "eth": [],
        "notifId": token["token"]
      };
      print(userDb);
      var db = FirebaseFirestore.instance;
      var o =
          await db.collection("users").doc(credential.user!.uid).set(userDb);
      print("O");
      getUserData();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  get currentUser {
    var user = _auth.currentUser;
    if (user == null) {
      print("no user");
      return 0;
    } else {
      return user;
      print('user');
    }
  }

  Future getVPA() async {
    var db = FirebaseFirestore.instance;
    var userData =
        await db.collection('users').doc(_auth.currentUser!.uid).get();
    return userData.data()!['vpa'];
  }

  Future<void> updatePrimaryAccount(String acc) async {
    var db = FirebaseFirestore.instance;
    await db
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update({"primaryAccount": acc.toLowerCase()});
    await getUserData();
  }

  Future updateAccountInfo(name, vpa) async {
    var db = FirebaseFirestore.instance;

    var originalData =
        await db.collection("users").doc(_auth.currentUser!.uid).get();

    var data = originalData.data();

    var reqs = await db
        .collection("paymentRequests")
        .where("receiver", isEqualTo: data!['vpa'])
        .get();
    var batch = db.batch();

    for (var element in reqs.docs) {
      batch.update(element.reference, {"receiver": vpa});
    }
    await batch.commit();
    await db
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update({"name": name, "vpa": vpa});

    await getUserData();
    return "1";
    // }
  }
}
