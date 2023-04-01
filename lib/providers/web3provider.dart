import 'package:flutter/cupertino.dart';

import '../env/env.dart';

class Web3EthProvider with ChangeNotifier {
  double etherCount = 0.0;
  int rupee = 0;

  String exchangeAPI = Env.EXCHANGEKEY;

  String rpcUrl = Env.DEV;
}

class Web3SolProvider with ChangeNotifier {}
