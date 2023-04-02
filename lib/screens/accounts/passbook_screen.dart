import 'package:flutter/material.dart';
import 'package:hack7/main.dart';
import 'package:hack7/providers/authprovider.dart';
import 'package:hack7/providers/fbdbprovider.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/screens/accounts/account_qr.dart';
import 'package:hack7/screens/accounts/transaction_details.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/balance_box.dart';
import 'package:hack7/widgets/key_dialog.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class Passbook extends StatefulWidget {
  const Passbook({Key? key}) : super(key: key);
  static const routename = '/passbook';

  @override
  State<Passbook> createState() => _PassbookState();
}

class _PassbookState extends State<Passbook> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.mainBlue,
        title: Text("Passbook: ${args['name']!}"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => KeyDialog(args['address']!));
              },
              icon: const Icon(
                Icons.security,
                size: 30,
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AccountQr(args['name']!, args['address']!)));
        },
        tooltip: "Share address",
        child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                AppTheme.mainBlue,
                HexColor('#6A88E5'),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: const Icon(Icons.share)),
      ),
      body: RefreshIndicator(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Column(
            children: [
              Balance(args['address']!),
              const Divider(),
              Container(
                // color: Colors.blue,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  "Transaction History:",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder(
                  future: Future.wait([
                    Provider.of<DbProvider>(context).gettransactions(
                        args['address']!,
                        Provider.of<AuthService>(context, listen: false)
                            .loggedInUser
                            .name,
                        "ETH"), //Future that returns bool
                    // _getAuthSession(), //Future that returns bool
                    Provider.of<Web3EthProvider>(context, listen: false)
                        .getEtherExchange()
                  ]),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      var data = snapshot.data![0] as List;
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (ctx, i) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    TransactionDetailScreen.routename);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Image.network(
                                        "https://cdn-icons-png.flaticon.com/512/625/625599.png"),
                                  ),
                                  title: Text(
                                      data[i]['receiver'] == args['address']!
                                          ? "Received from McDonald's"
                                          : "Sent to McDonald's"),
                                  subtitle: Text(DateFormat("dd/MM/yy hh:mm a")
                                      .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              data[i]['timestamp']))),
                                  trailing: Text(
                                    data[i]['receiver'] == args['address']!
                                        ? '+ \u{20B9}${data[i]['amount']}'
                                        : '- \u{20B9}${data[i]['amount']}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: data.length,
                        ),
                      );
                    }
                  })),
            ],
          ),
        ),
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            setState(() {});
          });
        },
      ),
    );
  }
}
