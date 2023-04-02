import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solana_web3/rpc_config/index.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class KJHTokenProvider extends StatefulWidget {
  const KJHTokenProvider({Key? key}) : super(key: key);

  @override
  State<KJHTokenProvider> createState() => _KJHTokenProviderState();
}

class _KJHTokenProviderState extends State<KJHTokenProvider> {
  late Client httpClient;
  late Web3Client ethClient;
  final address = "0x3C16855E6Ae4dFe027F9Bfc9FAb71114d18C9db9";

  double _value = 0.0;
  int myAmount = 0;
  var myData;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://mainnet.infura.io/v3/1401560e29a649eb9ce69070e3aa5c29",
        httpClient);
    getBalance(address);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/KJHTokenABI.json");
    String contractAddress = "0x3C16855E6Ae4dFe027F9Bfc9FAb71114d18C9db9";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "KJH"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<void> getBalance(String targetAddress) async {
    List<dynamic> result = await query("getBalance", []);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
