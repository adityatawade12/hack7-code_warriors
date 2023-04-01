import 'package:flutter/material.dart';
import 'package:hack7/themes/apptheme.dart';

class TransactionDetails extends StatelessWidget {
  const TransactionDetails({Key? key}) : super(key: key);
  static const routename = '/transactionDetails';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Details"),
        backgroundColor: AppTheme.mainBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Transaction ID:",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "0xe3e2357e806b6cdb1f70b54c3a3a17b6714ee1f0e68bebb44a74b1efd512098",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            Divider(
              height: 28,
            ),
            Text(
              "Amount:",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '- \u{20B9}50',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Val transaction:",
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1',
                          style: TextStyle(fontSize: 19),
                        ),
                        Container(
                          height: 20,
                          child: Image.network(
                              "https://cdn-icons-png.flaticon.com/512/7829/7829596.png"),
                        ),
                        Text(
                          ' = \u{20B9}500000',
                          style: TextStyle(color: Colors.black, fontSize: 19),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Curr. value: "),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1',
                          style: TextStyle(fontSize: 19),
                        ),
                        Container(
                          height: 20,
                          child: Image.network(
                              "https://cdn-icons-png.flaticon.com/512/7829/7829596.png"),
                        ),
                        Text(
                          ' = \u{20B9}50',
                          style: TextStyle(color: Colors.black, fontSize: 19),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            Divider(
              height: 28,
            ),
            Text(
              "Sender:",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Aditya Tawade",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Address: 0xasdb979y8asldjas",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            Divider(
              height: 28,
            ),
// ////////////////////////
            Text(
              "Receiver:",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Omkar Tawade",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Address: 0xasdb9868asldjas",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
