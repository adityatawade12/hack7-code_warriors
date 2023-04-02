import 'package:flutter/material.dart';
import 'package:hack7/providers/web3provider.dart';
import 'package:hack7/screens/accounts/passbook_transacton_screen.dart';
import 'package:hack7/themes/apptheme.dart';
import 'package:hack7/widgets/account/account_tile.dart';
import 'package:provider/provider.dart';

class AccountTileList extends StatefulWidget {
  final String type;
  const AccountTileList(
      {Key? key,
      this.animationController,
      this.animation,
      required this.onGoBack,
      required this.type})
      : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;
  final onGoBack;

  @override
  State<AccountTileList> createState() => _AccountTileListState();
}

class _AccountTileListState extends State<AccountTileList> {
  var web3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == "eth") {
      print("eth");
      web3 = Provider.of<Web3EthProvider>(context, listen: false);
    } else {
      print("sol");
      web3 = Provider.of<Web3SolProvider>(context, listen: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 18),
                child: SizedBox(
                  height: 350,
                  // color: Colors.amber,
                  width: double.infinity,
                  // color: Colors.yellow,
                  child: FutureBuilder(
                    future: web3.fetchStoredAccounts(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.mainBlue,
                          ),
                        );
                      } else {
                        if (web3.storedAccounts.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 45),
                            child: Container(
                              height: 100,
                              // margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    topRight: Radius.circular(68.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppTheme.grey.withOpacity(0.2),
                                      offset: const Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 16, right: 16, bottom: 16),
                                // child: NewWidget(),
                                child: SizedBox(
                                  height: 130,
                                  width: double.infinity,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.account_balance,
                                          size: 55,
                                          color: AppTheme.nearlyDarkBlue,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "No Accounts yet!",
                                          style: TextStyle(
                                            color: AppTheme.mainBlue,
                                            fontFamily: AppTheme.fontName,
                                            fontSize: 18,
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          // controller: scrollController,
                          padding: EdgeInsets.only(
                            // top: AppBar().preferredSize.height +
                            //     MediaQuery.of(context).padding.top +
                            //     24,
                            bottom: 110 + MediaQuery.of(context).padding.bottom,
                          ),
                          itemCount: web3.storedAccounts.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (ctx, int index) {
                            widget.animationController?.forward();
                            return InkWell(
                              onTap: (() {
                                widget.animationController!
                                    .reverse()
                                    .then((value) {
                                  print("lol");
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (ctx) =>
                                              PassBookAndTransactionScreen(
                                                address: web3
                                                    .storedAccounts[index]
                                                    .accountAddress,
                                                name: web3
                                                    .storedAccounts[index].name,
                                                type: widget.type,
                                              )))
                                      .then(widget.onGoBack);
                                });
                              }),
                              child: AccountTile(
                                accountName: web3.storedAccounts[index].name,
                                accountAddress:
                                    web3.storedAccounts[index].accountAddress,
                                animation: widget.animation,
                                animationController: widget.animationController,
                              ),
                            );
                          },
                        );
                        return const SizedBox(
                          height: 0,
                        );
                      }
                    },
                  ),
                )),
          ),
        );
      },
    );
  }
}
