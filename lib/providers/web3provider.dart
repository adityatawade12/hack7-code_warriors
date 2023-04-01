import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:hack7/models/account.dart';
import 'package:hive/hive.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../env/env.dart';

class Web3EthProvider with ChangeNotifier {
  double etherCount = 0.0;
  int rupee = 0;

  String exchangeAPI = Env.EXCHANGEKEY;

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

    return Account(newAccount.accountAddress, plainText, name, category);
  }
}

class Web3SolProvider with ChangeNotifier {}
