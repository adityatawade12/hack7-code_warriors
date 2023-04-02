import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hack7/models/account.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/screens/payment/pay_pin_screen.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:provider/provider.dart';

class PayScreen extends StatefulWidget {
  // const PayScreen({Key? key}) : super(key: key);
  static const routename = '/pay';
  double textfieldwidth = 40;
  int renderCount = 1;

  Account selectedAccount = Account('', '', '', "");
  List<Account> allAccounts = [];
  bool _value = false;
  bool _loading = true;
  int selectedAccountBalance = 0;
  final String recvAccount;
  final String name;
  final String vpa;
  final String type;

  PayScreen(this.recvAccount, this.name, this.vpa, this.type);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final payController = TextEditingController();
  @override
  void initState() {
    super.initState();
    var web3;
    if (widget.type == "sol") {
      web3 = Provider.of<Web3SolProvider>(context, listen: false);
    } else {
      web3 = Provider.of<Web3EthProvider>(context, listen: false);
    }

    web3.fetchStoredAccounts().then((data) {
      setState(() {
        widget.allAccounts = web3.storedAccounts;
        widget.selectedAccount = web3.storedAccounts[0];
        widget._loading = false;
      });
    });
  }

  void _showModalSheet(List<Account> allAccounts, web3) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, setState1) {
            return Container(
                height: 400.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Pay using:",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 19),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: allAccounts.length,
                          itemBuilder: ((context, index) {
                            return Card(
                              child: RadioListTile(
                                title: Text(
                                  allAccounts[index].name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(allAccounts[index].accountAddress),
                                    Row(
                                      children: [
                                        const Text(
                                          "Balance: \u{20B9} ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        FutureBuilder(
                                            future: web3.getAccountBalance(
                                                allAccounts[index]
                                                    .accountAddress),
                                            builder: ((context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: Container(
                                                      height: 15,
                                                      width: 15,
                                                      child:
                                                          const CircularProgressIndicator()),
                                                );
                                              } else {
                                                if (snapshot.error != null) {
                                                  return const Center(
                                                    child: Text(
                                                        "An error occurred"),
                                                  );
                                                }
                                                var data = snapshot.data
                                                    as Map<String, dynamic>;
                                                return Text(
                                                  data['rupee'].toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                );
                                              }
                                            }))
                                      ],
                                    )
                                  ],
                                ),
                                groupValue: widget.selectedAccount,
                                value: allAccounts[index],
                                // selected: widget._value,
                                onChanged: (value) {
                                  setState(() {
                                    widget.selectedAccount = allAccounts[index];
                                    widget._value = true;
                                    setState1(() {});
                                  });
                                },
                              ),
                            );
                          })),
                    )
                  ],
                ));
          });
        });
  }

  ifVpaExist() {
    if (widget.vpa.length != 0) {
      return ([
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.vpa,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var web3;
    if (widget.type == "sol") {
      web3 = Provider.of<Web3SolProvider>(context, listen: false);
    } else {
      web3 = Provider.of<Web3EthProvider>(context, listen: false);
    }

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(children: [
            const SizedBox(
              height: 35,
            ),
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 35,
                      )),
                ],
              ),
            ),
            Text(
              widget.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.mainBlue),
            ),
            ...ifVpaExist(),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.recvAccount,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Pay:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.currency_rupee,
                  size: 40,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 40),
                  child: IntrinsicWidth(
                    child: TextField(
                      controller: payController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "0"),
                      style: const TextStyle(fontSize: 30),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
                height: 30,
                child: FutureBuilder(
                    future: (widget.type == "eth")
                        ? web3.getEtherExchange()
                        : web3.getSolExchange(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Container(
                              width: 30,
                              child: const CircularProgressIndicator()),
                        );
                      } else {
                        if (snapshot.error != null) {
                          return const Center(
                            child: Text("An error occurred"),
                          );
                        }
                        var data = snapshot.data as int;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 20,
                              child: Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/7829/7829596.png"),
                            ),
                            const Text(" 1 = ", style: TextStyle(fontSize: 19)),
                            Text(
                              "\u{20B9} " + data.toStringAsFixed(0),
                              style: const TextStyle(fontSize: 19),
                            ),
                          ],
                        );
                      }
                    }))),
            const Spacer(),
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: widget._loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          ListTile(
                            title: Text(widget.selectedAccount.name),
                            subtitle:
                                Text(widget.selectedAccount.accountAddress),
                            trailing: IconButton(
                                onPressed: () =>
                                    _showModalSheet(widget.allAccounts, web3),
                                icon:
                                    const Icon(Icons.change_history_outlined)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50)),
                            onPressed: () async {
                              if (payController.text != '' ||
                                  int.parse(payController.text) >= 0) {
                                print("qwe");
                                var bal = await web3.getAccountBalance(
                                    widget.selectedAccount.accountAddress);
                                print(widget.selectedAccount.accountAddress);
                                if (bal['rupee'] <=
                                    int.parse(payController.text)) {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Not enough balance!",
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text("Ok"))
                                          ],
                                        );
                                      });
                                } else {
                                  var extra = await web3.getPayableAmount(
                                    int.parse(payController.text),
                                    widget.selectedAccount.accountAddress,
                                    widget.recvAccount,
                                  );
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => PayPinScreen(
                                          widget.selectedAccount.accountAddress,
                                          widget.recvAccount,
                                          int.parse(payController.text),
                                          extra,
                                          widget.type)));
                                }
                              }
                            },
                            child: const Text(
                              'Pay',
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ])),
    );
  }
}
