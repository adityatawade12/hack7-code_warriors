import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DbProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;

  Future checkVPA(String vpa) async {
    var status =
        await firestore.collection('users').where("vpa", isEqualTo: vpa).get();

    if (status.docs.length > 0) {
      return "0";
    } else {
      return "1";
    }
  }

  Future checkVPAValidity(String vpa) async {
    var status =
        await firestore.collection('users').where("vpa", isEqualTo: vpa).get();

    if (status.docs.length > 0) {
      return "0";
    } else {
      return "1";
    }
  }

  Future<Map<String, String>> getVPA(String vpa, String type) async {
    var status =
        await firestore.collection('users').where("vpa", isEqualTo: vpa).get();
    var data = status.docs[0].data() as Map<String, dynamic>;

    return {
      "address": (type == "eth")
          ? status.docs[0].data()['primaryAccountEth']
          : status.docs[0].data()['primaryAccountSol'],
      "name": status.docs[0].data()['name']
    };
  }

  Future<List> gettransactions(String acc, String name, String type) async {
    // print('gettransLol' + acc);
    var sent = await firestore
        .collection('transactions')
        .where("sender", isEqualTo: acc)
        .where("currency", isEqualTo: type)
        .get();

    var recvd = await firestore
        .collection('transactions')
        .where("receiver", isEqualTo: acc)
        .get();

    var data = [];
    var otherAcc = [];
    sent.docs.forEach((element) {
      data.add(element.data() as Map<String, dynamic>);
      otherAcc.add(element['receiver']);
    });
    otherAcc.add('');
    recvd.docs.forEach((element) {
      data.add(element.data() as Map<String, dynamic>);
      otherAcc.add(element['sender']);
    });

    otherAcc = otherAcc.toSet().toList();

    final accountNames = await firestore
        .collection('users')
        .where(type.toLowerCase(), arrayContainsAny: otherAcc)
        .get();

    var c = 0;
    for (var element in data) {
      c += 1;

      element['receiverName'] = "";
      element['senderName'] = "";

      if (element['sender'] == acc) {
        element['senderName'] = name;

        for (var e1 in accountNames.docs) {
          var e = e1.data();

          if (e[type].contains(element['receiver'])) {
            element['receiverName'] = e['name'];
          }
        }
        // element['receiverName']=
      } else {
        element['receiverName'] = name;

        for (var e1 in accountNames.docs) {
          var e = e1.data();

          if (e[type].contains(element['sender'])) {
            element['senderName'] = e['name'];
          }
        }
      }
      // print("end of loop");
    }
    // print("data3");
    // print(data.length);

    data.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    // print("transList=========================");
    // print(data);

    return data;
  }

  Future checkVPAValidityForPayment(vpa, type) async {
    var status = await firestore
        .collection('users')
        .where("vpa", isEqualTo: vpa)
        .where((type == "eth") ? "primaryAccountEth" : "primaryAccountSol",
            isNotEqualTo: "")
        .get();
    // print(status.docs.length);
    if (status.docs.length > 0) {
      return true;
    }
    return false;
  }

  Future getAccountname(address, type) async {
    var doc = await firestore
        .collection('users')
        .where(type, arrayContainsAny: [address]).get();
    if (doc.docs.length == 0) {
      return "Unregistered User";
    }
    return doc.docs[0].data()['name'];
  }
}
