import 'package:flutter/material.dart';
import 'package:hack7/providers/authprovider.dart';
import 'package:hack7/providers/fbdbprovider.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/screens/payment/request_pay_screen.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/transaction/no_transaction_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RequestList extends StatefulWidget {
  const RequestList(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.onGoBack})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  // final String address;
  final onGoBack;

  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList>
    with TickerProviderStateMixin {
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var web3 = Provider.of<Web3EthProvider>(context, listen: false);
    var auth = Provider.of<AuthService>(context, listen: false);
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
                  height: 620,
                  // color: Colors.amber,
                  width: double.infinity,
                  // color: Colors.yellow,
                  child: FutureBuilder(
                      future: web3.getPaymentRequests(auth.loggedInUser.vpa),
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
                          // print(data);
                          if (snapshot.hasData) {
                            var data = snapshot.data! as List;
                            return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: ((ctx, i) {
                                  // var i = 1;
                                  return InkWell(
                                    onTap: (() async {
                                      var address = data[i]["sender"];
                                      var name = await Provider.of<DbProvider>(
                                              context,
                                              listen: false)
                                          .getAccountname(address, 'eth');
                                      print("===================");
                                      print(address);
                                      print(name);
                                      print(data[i]["amount"]);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  RequestPayScreen(
                                                      address,
                                                      name,
                                                      "",
                                                      data[i]["amount"])));
                                      // widget.mainScreenAnimationController!
                                      //     .reverse()
                                      //     .then((value) {
                                      //   var address = data[i]["sender"];

                                      //   var vpa = "";

                                      // });
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
                                              "assets/images/pay.png"),
                                        ),
                                        title: Text(data[i]["senderName"]),
                                        subtitle: Text(
                                            DateFormat("dd/MM/yy hh:mm a")
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        data[i]['timestamp']))),
                                        trailing: Text(
                                          "\u{20B9}${data[i]['amount']}",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  );
                                }));
                          } else {
                            return NoTransaction(
                              title: "No Pending Requests!",
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
