import 'dart:convert';

import 'package:flutter/material.dart';
import '../order.dart';
import '/user.dart';
import 'package:http/http.dart' as http;
import '/myconfig.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfirmScreen extends StatefulWidget {
  final User user;
  final Order order;

  const ConfirmScreen({super.key, required this.user, required this.order});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Bill", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: Text(
                "Confirmation Successfull",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
            ),
            ElevatedButton(
              onPressed: () {
                submitStatus();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: const Text("Trade Successful"),
            ),
          ],
        ),
      ),
    );
  }

  void submitStatus() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterlt/php/set_orderstatus.php"),
        body: {
          "orderid": widget.order.orderId,
          "status": "Completed",
        }).then((response) {
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
        } else {}
        widget.order.orderStatus = "Completed";
        setState(() {});
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
