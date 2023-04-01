import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:hack7/models/account.dart';
import 'package:hive/hive.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../env/env.dart';

class Web3EthProvider with ChangeNotifier {
  double etherCount = 0.0;
  int rupee = 0;
  List<Account> _accounts = [];
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

    return Account(newAccount.accountAddress, plainText, name);
  }

  Future<void> fetchStoredAccounts() async {
    print('Fetch User');
    print(FirebaseAuth.instance.currentUser);
    var db = FS.FirebaseFirestore.instance;
    var userD = await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var accs = userD.data()!['accounts'];

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
}

class Web3SolProvider with ChangeNotifier {}

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
