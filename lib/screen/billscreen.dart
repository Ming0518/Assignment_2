import 'dart:convert';

import 'package:barterlt/screen/statusbill.dart';
import 'package:flutter/material.dart';
import '/user.dart';
import 'failstatus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barterlt/myconfig.dart';
import 'package:http/http.dart' as http;

class BillScreen extends StatefulWidget {
  final User user;

  const BillScreen({super.key, required this.user});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
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
                "Payment Simulator",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "RM 1.00",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addtoorder();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatusBill(user: widget.user),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: const Text("Successful Payment"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FailStatusBill(user: widget.user),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: const Text("Unsuccessful Payment"),
            ),
          ],
        ),
      ),
    );
  }

  void addtoorder() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/payment.php"),
        body: {
          "userid": widget.user.id,
          "email": widget.user.email,
          "phone": widget.user.phone,
          "name": widget.user.name,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(const SnackBar(content: Text("Success")));
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.pop(context);
      }
    });
  }
}
