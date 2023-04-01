import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart' as FS;
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hack7/models/account.dart';
import 'package:hive/hive.dart';
import 'package:solana_web3/programs/system.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import '../env/env.dart';
import 'package:solana_web3/solana_web3.dart' as web3;

class Web3EthProvider with ChangeNotifier {
  double etherCount = 0.0;
  int rupee = 0;
  List<Account> _accounts = [];
  String exchangeAPI = Env.EXCHANGEKEYETH;

  String rpcUrl = Env.DEV;

  @override
  Future<Account> createNewAccount(
      String name, String pin, String category) async {
    //Generating pin hash
    final hashingAlgo = Sha256();
    final hash = await hashingAlgo.hash(utf8.encode(pin));
    var pin2 = bytesToHex(hash.bytes);

    // Creating account
    var rng = Random.secure();
    EthPrivateKey credentials = EthPrivateKey.createRandom(rng);
    var address = await credentials.extractAddress();

    //Encrypting account private key
    EncryptionLib enc = EncryptionLib();
    String plainText = bytesToHex(credentials.privateKey);
    var encrypted = enc.encryptAESCryptoJS(plainText, pin2);

    Account newAccount = Account(address.hex, encrypted, name, category);

    // var decrypted = enc.decryptAESCryptoJS(encrypted, pin2);

    var accounts = await Hive.openBox<Account>('accounts');
    await accounts.put(newAccount.accountAddress, newAccount);
    await fetchStoredAccounts();
    var db = FS.FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "accounts": FS.FieldValue.arrayUnion([newAccount.accountAddress]),
    });
    notifyListeners();

    return Account(newAccount.accountAddress, plainText, name, 'eth');
  }

  Future<Account> importAccount(
      String name, String pin, String privateKey, String category) async {
    //Generating pin hash
    final hashingAlgo = Sha256();
    final hash = await hashingAlgo.hash(utf8.encode(pin));
    var pin2 = bytesToHex(hash.bytes);

    // Creating account

    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    var address = await credentials.extractAddress();

    //Encrypting account private key
    EncryptionLib enc = EncryptionLib();
    String plainText = bytesToHex(credentials.privateKey);
    var encrypted = enc.encryptAESCryptoJS(plainText, pin2);

    Account newAccount = Account(address.hex, encrypted, name, category);

    // var decrypted = enc.decryptAESCryptoJS(encrypted, pin2);

    var accounts = await Hive.openBox<Account>('accounts');
    await accounts.put(newAccount.accountAddress, newAccount);
    await fetchStoredAccounts();
    var db = FS.FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "accounts": FS.FieldValue.arrayUnion([newAccount.accountAddress]),
    });

    notifyListeners();

    return Account(newAccount.accountAddress, plainText, name, category);
  }

  Future<void> fetchStoredAccounts() async {
    print('Fetch User');
    print(FirebaseAuth.instance.currentUser);
    var db = FS.FirebaseFirestore.instance;
    var userD = await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var accs = userD.data()!['eth'];

    var accounts = await Hive.openBox<Account>('accounts');

    List<Account> items = [];
    for (var element in accs) {
      if (accounts.get(element) != null) {
        items.add(accounts.get(element)!);
      }
    }

    // print(it);
    // var items = accounts.values.toList().reversed.toList();
    // accounts.close();
    _accounts = items;

    notifyListeners();
    // return items;
  }

  Future<Map<String, dynamic>> getAccountBalance(String account) async {
    final client = Web3Client(rpcUrl, http.Client());

    final address = EthereumAddress.fromHex(account);

    var balance = await client.getBalance(address);

    try {
      var url = Uri.parse(exchangeAPI);
      final response = await http.get(url);

      if (json.decode(response.body) == null) {
        return {"rupee": 0, "ether": 0.0};
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      rupee = extractedData['ethereum']!['inr'];

      return {
        "rupee": (rupee * balance.getValueInUnit(EtherUnit.ether)).floor(),
        "ether": balance.getValueInUnit(EtherUnit.ether)
      };
    } catch (e) {
      return {"rupee": 0, "ether": 0.0};
    }
  }

  List<Account> get storedAccounts {
    return [..._accounts];
  }

  Future<Map<String, dynamic>> decryptPrivatekey(
      String address, String pin) async {
    var accounts = await Hive.openBox<Account>('accounts');
    var acc = accounts.get(address);
    final hashingAlgo = Sha256();
    final hash = await hashingAlgo.hash(utf8.encode(pin));
    var pin2 = bytesToHex(hash.bytes);
    EncryptionLib enc = EncryptionLib();
    var decryptedKey = enc.decryptAESCryptoJS(acc!.privateKey, pin2);
    // print(decryptedKey);
    if (decryptedKey == "lol") {
      return {"status": "fail"};
    } else {
      return {"status": "pass", "key": decryptedKey};
    }
  }

  Future<int> getEtherExchange() async {
    try {
      var url = Uri.parse(exchangeAPI);
      final response = await http.get(url);
      if (json.decode(response.body) == null) {
        return 0;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      rupee = extractedData['ethereum']!['inr'];
      // rupee = extractedData['INR']!.floor();
      print("Rupee:");
      print(rupee);
      return rupee;

      // notifyListeners();
    } catch (e) {
      print(e);
      return 0;
    }
    return 1;
  }

  Future<int> makePayment(
      String senderAddress, String recvAddress, privKey, amt) async {
    final client = Web3Client(rpcUrl, http.Client());
    // "0xb634386141e7b34898e7684d355bf67da40b0e5e"
    final address = EthereumAddress.fromHex(recvAddress);
    final credentials = EthPrivateKey.fromHex(privKey);
    var ex = await getEtherExchange();
    BigInt we = BigInt.from(1000000000000000000);
    BigInt c = BigInt.from(ex);
    BigInt m = BigInt.from(amt);
    BigInt x = m * we ~/ c;
    // ;
    print("==");
    print(x);
    // "0x858c4f9506ddf2904d14aa619580e193cba4bfb4"
    var maxgas = await client.estimateGas(
        sender: EthereumAddress.fromHex(senderAddress),
        to: address,
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, x));
    print(maxgas.toInt());
    print(EtherAmount.fromUnitAndValue(EtherUnit.wei, x));
    print(EtherAmount.fromUnitAndValue(EtherUnit.ether, x));
    try {
      var trns = await client.sendTransaction(
          credentials,
          Transaction(
            to: address,

            // maxGas: balance,
            gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),

            maxGas: maxgas.toInt(),
            value: EtherAmount.fromUnitAndValue(EtherUnit.wei, x),
          ),
          chainId: (await client.getChainId()).toInt());
      // chainId: (await client.getChainId()).toInt()
      // 882104359078718053
      // 4505722723997348
      print(trns);
      print("After trns");
      var db = FS.FirebaseFirestore.instance;
      final userDb = <String, dynamic>{
        "sender": senderAddress.toLowerCase(),
        "receiver": recvAddress.toLowerCase(),
        "transactionHash": trns,
        "amount": amt,
        "exchange": ex,
        "currency": "ETH",
        "timestamp": DateTime.now().millisecondsSinceEpoch
      };

      db.collection("transactions").doc().set(userDb);
      var obj = await db.collection('users').where("accounts",
          arrayContainsAny: [recvAddress.toLowerCase()]).get();

      // var senderuser=await db.collection("users").
      print("Object:");
      print(obj.docs[0].data());

      if (obj.docs.length > 0) {
        try {
          var reqBody = {
            "to": obj.docs[0].data()['notifId'],
            "data": {
              "message":
                  "Received Rs.${userDb["amount"]} from ${senderAddress}",
              "transactionId": userDb["transactionHash"]
            },
          };
          Response response = await Dio().post(
            "https://api.pushy.me/push?api_key=" + Env.NOTIFKEY,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(reqBody),
          );

          print("printing response");
          print(response.data);
          print(response.data.runtimeType);
        } catch (e) {
          print("===================");
          print(e);
        }
      }

      return 1;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future createPaymentRequest(amt, sender, receiver) async {
    var firestore = FS.FirebaseFirestore.instance;
    final paymentObject = <String, dynamic>{
      "sender": sender,
      "receiver": receiver,
      "amount": amt,
      "status": "pending",
      "currency": "ETH",
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    var obj1 =
        await firestore.collection("paymentRequests").doc().set(paymentObject);
    var obj = await firestore
        .collection('users')
        .where("vpa", isEqualTo: receiver)
        .get();

    // var senderuser=await db.collection("users").
    print("Object:");
    print(obj.docs[0].data());

    if (obj.docs.length > 0) {
      try {
        var reqBody = {
          "to": obj.docs[0].data()['notifId'],
          "data": {
            "message": "Payment Request from ${sender} of Rs${amt}",
          },
        };
        Response response = await Dio().post(
          "https://api.pushy.me/push?api_key=" + Env.NOTIFKEY,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(reqBody),
        );

        // if (json.decode(response.body) == null) {
        //   return {"rupee": 0, "ether": 0.0};
        // }
        print("printing response");
        print(response.data);
        print(response.data.runtimeType);
        // final extractedData =
        //     json.decode(response.body) as Map<String, dynamic>;
        // print(extractedData);
      } catch (e) {
        print("===================");
        print(e);
      }
    }
  }

  Future getPayableAmount(amt, senderAddress, recvAddress) async {
    final client = Web3Client(rpcUrl, http.Client());

    print(senderAddress);
    final address = EthereumAddress.fromHex(recvAddress);
    // final credentials = EthPrivateKey.fromHex(privKey);
    var ex = await getEtherExchange();
    BigInt we = BigInt.from(1000000000000000000);
    BigInt c = BigInt.from(ex);
    BigInt m = BigInt.from(amt);
    BigInt x = m * we ~/ c;
    // ;
    BigInt maxgas = await client.estimateGas(
        sender: EthereumAddress.fromHex(senderAddress),
        to: address,
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, x));
    var extraSpend =
        (c * maxgas * EtherAmount.inWei(BigInt.from(2000000000)).getInWei / ~we)
            .abs()
            .ceil();
    return extraSpend;
  }

  Future getPaymentRequests(vpa) async {
    var firestore = FS.FirebaseFirestore.instance;
    var requests = await firestore
        .collection('paymentRequests')
        .where("receiver", isEqualTo: vpa)
        .where("currency", isEqualTo: "ETH")
        .get();
    if (requests.docs.length == 0) {
      return null;
    }
    var data = [];
    var otherAcc = [];
    requests.docs.forEach((element) {
      data.add(element.data() as Map<String, dynamic>);
      otherAcc.add(element['sender']);
    });

    // print(otherAcc);
    final accountNames = await firestore
        .collection('users')
        .where("accounts", arrayContainsAny: otherAcc)
        .get();

    for (var element in data) {
      print("Index");
      print(element);

      element['senderName'] = "";

      element['receiverName'] = "Ady";

      for (var e1 in accountNames.docs) {
        var e = e1.data();
        print("asdas");
        print(e);
        if (e['accounts'].contains(element['sender'])) {
          element['senderName'] = e['name'];
        }
      }
      // }
    }

    data.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    print("transList");
    print(data);

    return data;
  }
}

class Web3SolProvider with ChangeNotifier {
  List<Account> _accounts = [];
  String rpcUrl = Env.SOL;
  int rupee = 0;
  String exchangeAPI = Env.EXCHANGEKEYSOL;

  Future<Account> createNewAccount(
      String name, String pin, String category) async {
    final cluster = web3.Cluster.devnet;
    web3.Connection connection = web3.Connection(cluster);

    final wallet1 = web3.Keypair.generateSync();
    final address1 = wallet1.publicKey;
    final hashingAlgo = Sha256();
    final hash = await hashingAlgo.hash(utf8.encode(pin));
    var pin2 = bytesToHex(hash.bytes);

    //Encrypting account private key
    EncryptionLib enc = EncryptionLib();
    String plainText = bytesToHex(wallet1.secretKey);
    var encrypted = enc.encryptAESCryptoJS(plainText, pin2);

    Account newAccount = Account(address1.toString(), encrypted, name, 'sol');

    var accounts = await Hive.openBox<Account>('accounts');
    await accounts.put(newAccount.accountAddress, newAccount);
    await fetchStoredAccounts();
    var db = FS.FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "sol": FS.FieldValue.arrayUnion([newAccount.accountAddress]),
    });
    notifyListeners();

    return newAccount;
  }

  Future<Account> importAccount(
      String name, String pin, String privateKey, String category) async {
    //Generating pin hash
    final hashingAlgo = Sha256();
    final hash = await hashingAlgo.hash(utf8.encode(pin));
    var pin2 = bytesToHex(hash.bytes);

    // Creating account
    final wallet1 = web3.Keypair.fromSecretKeySync(hexToBytes(privateKey));
    final address1 = wallet1.publicKey;

    //Encrypting account private key
    EncryptionLib enc = EncryptionLib();
    String plainText = bytesToHex(wallet1.secretKey);
    var encrypted = enc.encryptAESCryptoJS(plainText, pin2);

    Account newAccount = Account(address1.toString(), encrypted, name, 'sol');

    // var decrypted = enc.decryptAESCryptoJS(encrypted, pin2);

    var accounts = await Hive.openBox<Account>('accounts');
    await accounts.put(newAccount.accountAddress, newAccount);
    await fetchStoredAccounts();
    var db = FS.FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "sol": FS.FieldValue.arrayUnion([newAccount.accountAddress]),
    });

    notifyListeners();

    return Account(newAccount.accountAddress, plainText, name, category);
  }

  Future<void> fetchStoredAccounts() async {
    print('Fetch User');
    print(FirebaseAuth.instance.currentUser);
    var db = FS.FirebaseFirestore.instance;
    var userD = await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var accs = userD.data()!['sol'];

    var accounts = await Hive.openBox<Account>('accounts');

    List<Account> items = [];
    for (var element in accs) {
      if (accounts.get(element) != null) {
        items.add(accounts.get(element)!);
      }
    }

    // print(it);
    // var items = accounts.values.toList().reversed.toList();
    // accounts.close();
    _accounts = items;

    notifyListeners();
    // return items;
  }

  Future<Map<String, dynamic>> getAccountBalance(String account) async {
    final cluster = web3.Cluster.devnet;
    final connection = web3.Connection(cluster);

    final balance =
        await connection.getBalance(web3.PublicKey.fromString(account));

    try {
      var url = Uri.parse(exchangeAPI);
      final response = await http.get(url);

      if (json.decode(response.body) == null) {
        return {"rupee": 0, "sol": 0.0};
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      rupee = extractedData['sol']!['inr'];

      return {
        "rupee": (rupee * web3.lamportsToSol(BigInt.from(balance))).floor(),
        "sol": web3.lamportsToSol(BigInt.from(balance))
      };
    } catch (e) {
      return {"rupee": 0, "sol": 0.0};
    }
  }

  List<Account> get storedAccounts {
    return [..._accounts];
  }

  Future<Map<String, dynamic>> decryptPrivatekey(
      String address, String pin) async {
    var accounts = await Hive.openBox<Account>('accounts');
    var acc = accounts.get(address);
    final hashingAlgo = Sha256();
    final hash = await hashingAlgo.hash(utf8.encode(pin));
    var pin2 = bytesToHex(hash.bytes);
    EncryptionLib enc = EncryptionLib();
    var decryptedKey = enc.decryptAESCryptoJS(acc!.privateKey, pin2);
    // print(decryptedKey);
    if (decryptedKey == "lol") {
      return {"status": "fail"};
    } else {
      return {"status": "pass", "key": decryptedKey};
    }
  }

  Future<int> getSolExchange() async {
    try {
      var url = Uri.parse(exchangeAPI);
      final response = await http.get(url);
      if (json.decode(response.body) == null) {
        return 0;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      rupee = extractedData['sol']!['inr'];
      // rupee = extractedData['INR']!.floor();
      print("Rupee:");
      print(rupee);
      return rupee;

      // notifyListeners();
    } catch (e) {
      print(e);
      return 0;
    }
    return 1;
  }

  Future<int> makePayment(
      String senderAddress, String recvAddress, privKey, amt) async {
    final wallet1 = web3.Keypair.fromSecretKeySync(hexToBytes(privKey));
    final address1 = wallet1.publicKey;

    final cluster = web3.Cluster.devnet;
    final connection = web3.Connection(cluster);

    var ex = await getSolExchange();
    // BigInt we = BigInt.from(1000000000);
    // BigInt c = BigInt.from(ex);
    // BigInt m = BigInt.from(amt);
    // BigInt x = m * we ~/ c;

    var we = 1000000000;
    var c = ex;
    var m = amt;
    var x = m * we ~/ c;

    var blkhash = (await connection.getLatestBlockhash()).blockhash;
    print(blkhash);
    // Create a System Program instruction to transfer 1 SOL from [address1] to [address2].
    final transaction =
        web3.Transaction(feePayer: address1, recentBlockhash: blkhash);
    transaction.add(
      SystemProgram.transfer(
        fromPublicKey: address1,
        toPublicKey: web3.PublicKey.fromString(recvAddress),
        lamports: web3.solToLamports(x),
      ),
    );

    // "0x858c4f9506ddf2904d14aa619580e193cba4bfb4"
    var maxgas =
        await connection.getFeeForMessage(transaction.compileMessage());

    try {
      var trns = await connection.sendAndConfirmTransaction(
        transaction,
        signers: [wallet1], // Fee payer + transaction signer.
      );
      // var trns = await client.sendTransaction(
      //     credentials,
      //     Transaction(
      //       to: address,

      //       // maxGas: balance,
      //       gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),

      //       maxGas: maxgas.toInt(),
      //       value: EtherAmount.fromUnitAndValue(EtherUnit.wei, x),
      //     ),
      // chainId: (await client.getChainId()).toInt());
      // chainId: (await client.getChainId()).toInt()
      // 882104359078718053
      // 4505722723997348
      print(trns);
      print("After trns");
      var db = FS.FirebaseFirestore.instance;
      final userDb = <String, dynamic>{
        "sender": senderAddress.toLowerCase(),
        "receiver": recvAddress.toLowerCase(),
        "transactionHash": trns,
        "amount": amt,
        "exchange": ex,
        "currency": "SOL",
        "timestamp": DateTime.now().millisecondsSinceEpoch
      };

      db.collection("transactions").doc().set(userDb);
      var obj = await db.collection('users').where("accounts",
          arrayContainsAny: [recvAddress.toLowerCase()]).get();

      // var senderuser=await db.collection("users").
      print("Object:");
      print(obj.docs[0].data());

      if (obj.docs.length > 0) {
        try {
          var reqBody = {
            "to": obj.docs[0].data()['notifId'],
            "data": {
              "message":
                  "Received Rs.${userDb["amount"]} from ${senderAddress}",
              "transactionId": userDb["transactionHash"]
            },
          };
          Response response = await Dio().post(
            "https://api.pushy.me/push?api_key=" + Env.NOTIFKEY,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(reqBody),
          );

          // if (json.decode(response.body) == null) {
          //   return {"rupee": 0, "ether": 0.0};
          // }
          print("printing response");
          print(response.data);
          print(response.data.runtimeType);
          // final extractedData =
          //     json.decode(response.body) as Map<String, dynamic>;
          // print(extractedData);
        } catch (e) {
          print("===================");
          print(e);
        }
      }

      return 1;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future createPaymentRequest(amt, sender, receiver) async {
    var firestore = FS.FirebaseFirestore.instance;
    final paymentObject = <String, dynamic>{
      "sender": sender,
      "receiver": receiver,
      "amount": amt,
      "status": "pending",
      "currency": "SOL",
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    var obj1 =
        await firestore.collection("paymentRequests").doc().set(paymentObject);
    var obj = await firestore
        .collection('users')
        .where("vpa", isEqualTo: receiver)
        .get();

    // var senderuser=await db.collection("users").
    print("Object:");
    print(obj.docs[0].data());

    if (obj.docs.length > 0) {
      try {
        var reqBody = {
          "to": obj.docs[0].data()['notifId'],
          "data": {
            "message": "Payment Request from ${sender} of Rs${amt}",
          },
        };
        Response response = await Dio().post(
          "https://api.pushy.me/push?api_key=" + Env.NOTIFKEY,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(reqBody),
        );

        // if (json.decode(response.body) == null) {
        //   return {"rupee": 0, "ether": 0.0};
        // }
        print("printing response");
        print(response.data);
        print(response.data.runtimeType);
        // final extractedData =
        //     json.decode(response.body) as Map<String, dynamic>;
        // print(extractedData);
      } catch (e) {
        print("===================");
        print(e);
      }
    }
  }

  Future getPaymentRequests(vpa) async {
    var firestore = FS.FirebaseFirestore.instance;
    var requests = await firestore
        .collection('paymentRequests')
        .where("receiver", isEqualTo: vpa)
        .where("currency", isEqualTo: "SOL")
        .get();
    if (requests.docs.length == 0) {
      return null;
    }
    var data = [];
    var otherAcc = [];
    requests.docs.forEach((element) {
      data.add(element.data() as Map<String, dynamic>);
      otherAcc.add(element['sender']);
    });

    // print(otherAcc);
    final accountNames = await firestore
        .collection('users')
        .where("accounts", arrayContainsAny: otherAcc)
        .get();

    for (var element in data) {
      print("Index");
      print(element);

      element['senderName'] = "";

      element['receiverName'] = "Ady";

      for (var e1 in accountNames.docs) {
        var e = e1.data();
        print("asdas");
        print(e);
        if (e['accounts'].contains(element['sender'])) {
          element['senderName'] = e['name'];
        }
      }
      // }
    }

    data.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    print("transList");
    print(data);

    return data;
  }

  Future getPayableAmount(amt, senderAddress, recvAddress) async {
    final client = Web3Client(rpcUrl, http.Client());

    print(senderAddress);
    final address = EthereumAddress.fromHex(recvAddress);
    // final credentials = EthPrivateKey.fromHex(privKey);
    var ex = await getSolExchange();
    // BigInt we = BigInt.from(1000000000000000000);
    // BigInt c = BigInt.from(ex);
    // BigInt m = BigInt.from(amt);
    // BigInt x = m * we ~/ c;

    var we = 1000000000;
    var c = ex;
    var m = amt;
    var x = m * we ~/ c;

    // ;
    // BigInt maxgas = await client.estimateGas(
    //     sender: EthereumAddress.fromHex(senderAddress),
    //     to: address,
    //     value: EtherAmount.fromUnitAndValue(EtherUnit.wei, x));
    // var extraSpend =
    //     (c * maxgas * EtherAmount.inWei(BigInt.from(2000000000)).getInWei / ~we)
    //         .abs()
    //         .ceil();
    // return extraSpend;
  }
}

class EncryptionLib {
  String encryptAESCryptoJS(String plainText, String passphrase) {
    try {
      final salt = genRandomWithNonZero(8);
      var keyndIV = deriveKeyAndIV(passphrase, salt);
      final key = encrypt.Key(keyndIV.item1);
      final iv = encrypt.IV(keyndIV.item2);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      Uint8List encryptedBytesWithSalt = Uint8List.fromList(
          createUint8ListFromString("Salted__") + salt + encrypted.bytes);
      return base64.encode(encryptedBytesWithSalt);
    } catch (error) {
      throw error;
    }
  }

  String decryptAESCryptoJS(String encrypted, String passphrase) {
    try {
      Uint8List encryptedBytesWithSalt = base64.decode(encrypted);

      Uint8List encryptedBytes =
          encryptedBytesWithSalt.sublist(16, encryptedBytesWithSalt.length);
      final salt = encryptedBytesWithSalt.sublist(8, 16);
      var keyndIV = deriveKeyAndIV(passphrase, salt);
      final key = encrypt.Key(keyndIV.item1);
      final iv = encrypt.IV(keyndIV.item2);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final decrypted =
          encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
      return decrypted;
    } catch (error) {
      print('Error happended');
      print(error);
      return "lol";
      // throw error;
    }
  }

  Tuple2<Uint8List, Uint8List> deriveKeyAndIV(
      String passphrase, Uint8List salt) {
    var password = createUint8ListFromString(passphrase);
    Uint8List concatenatedHashes = Uint8List(0);
    Uint8List? currentHash = Uint8List(0);
    bool enoughBytesForKey = false;
    Uint8List preHash = Uint8List(0);

    while (!enoughBytesForKey) {
      int preHashLength = currentHash!.length + password.length + salt.length;
      if (currentHash.length > 0)
        preHash = Uint8List.fromList(currentHash + password + salt);
      else
        preHash = Uint8List.fromList(password + salt);

      currentHash = md5.convert(preHash).bytes as Uint8List?;
      concatenatedHashes =
          Uint8List.fromList(concatenatedHashes + currentHash!);
      if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
    }

    var keyBtyes = concatenatedHashes.sublist(0, 32);
    var ivBtyes = concatenatedHashes.sublist(32, 48);
    return Tuple2(keyBtyes, ivBtyes);
  }

  Uint8List createUint8ListFromString(String s) {
    var ret = Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  Uint8List genRandomWithNonZero(int seedLength) {
    final random = Random.secure();
    const int randomMax = 245;
    final Uint8List uint8list = Uint8List(seedLength);
    for (int i = 0; i < seedLength; i++) {
      uint8list[i] = random.nextInt(randomMax) + 1;
    }
    return uint8list;
  }
}
