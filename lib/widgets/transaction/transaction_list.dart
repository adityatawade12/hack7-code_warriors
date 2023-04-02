import 'package:flutter/material.dart';
import 'package:hack7/providers/authprovider.dart';
import 'package:hack7/providers/fbdbprovider.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/screens/accounts/transaction_details.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/transaction/no_transaction_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatefulWidget {
  const TransactionList(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      required this.address,
      required this.type,
      this.onGoBack})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String address;
  final onGoBack;
  final String type;

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList>
    with TickerProviderStateMixin {
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 8),
                child: Container(
                  height: 352,
                  // color: Colors.amber,
                  width: double.infinity,
                  // color: Colors.yellow,
                  child: FutureBuilder(
                      future: (widget.type == "eth")
                          ? Future.wait([
                              Provider.of<DbProvider>(context, listen: false)
                                  .gettransactions(
                                      widget.address,
                                      Provider.of<AuthService>(context,
                                              listen: false)
                                          .loggedInUser
                                          .name,
                                      "ETH"), //Future that returns bool
                              // _getAuthSession(), //Future that returns bool
                              Provider.of<Web3EthProvider>(context,
                                      listen: false)
                                  .getEtherExchange()
                            ])
                          : Future.wait([
                              Provider.of<DbProvider>(context).gettransactions(
                                  widget.address,
                                  Provider.of<AuthService>(context,
                                          listen: false)
                                      .loggedInUser
                                      .name,
                                  "SOL"), //Future that returns bool
                              // _getAuthSession(), //Future that returns bool
                              Provider.of<Web3SolProvider>(context,
                                      listen: false)
                                  .getSolExchange()
                            ]),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.mainBlue,
                            ),
                          );
                        } else {
                          print("insode list");
                          print(snapshot.hasData);
                          print("insode list");
                          //
                          print(snapshot.data);
                          if (snapshot.hasData) {
                            var data = snapshot.data![0] as List;
                            return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: ((ctx, i) {
                                  // var i = 1;
                                  return InkWell(
                                    onTap: (() {
                                      widget.mainScreenAnimationController!
                                          .reverse()
                                          .then((value) {
                                        print("lol");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (cntx) =>
                                                    TransactionDetailScreen(
                                                      trns: data[i],
                                                      address: widget.address,
                                                      currEx: snapshot.data![1]
                                                          .toString(),
                                                    ))).then(widget.onGoBack);
                                      });
                                    }),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        // ignore: prefer_const_constructors
                                        borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(8.0),
                                            bottomLeft:
                                                const Radius.circular(8.0),
                                            bottomRight:
                                                const Radius.circular(30.0),
                                            topRight:
                                                const Radius.circular(5.0)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: AppTheme.grey
                                                  .withOpacity(0.2),
                                              offset: const Offset(1.1, 1.1),
                                              blurRadius: 10.0),
                                        ],
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          // child: Image.network(
                                          //     "https://cdn-icons-png.flaticon.com/512/625/625599.png"),
                                          child: Image.asset(
                                              data[i]['receiver'] ==
                                                      widget.address
                                                  ? "assets/images/recvIcon.png"
                                                  : "assets/images/sendIcon.png",
                                              fit: BoxFit.contain),
                                        ),
                                        title: Text(
                                          data[i]['receiver'] == widget.address
                                              ? "Received from ${data[i]['senderName']}"
                                              : "Sent to ${data[i]['receiverName']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Text(
                                            DateFormat("dd/MM/yy hh:mm a")
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        data[i]['timestamp']))),
                                        trailing: Text(
                                          data[i]['receiver'] == widget.address
                                              ? '+ \u{20B9}${data[i]['amount']}'
                                              : '- \u{20B9}${data[i]['amount']}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  );
                                }));
                          } else {
                            return NoTransaction(
                              title: "No Transactions yet!",
                              mainScreenAnimation: widget.mainScreenAnimation,
                              mainScreenAnimationController:
                                  widget.mainScreenAnimationController,
                            );
                          }
                        }
                      })),
                )),
          ),
        );
      },
    );
  }
}
