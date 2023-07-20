import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '/order.dart';
import '/user.dart';
import 'package:http/http.dart' as http;
import '/myconfig.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderScreen extends StatefulWidget {
  final User user;

  const OrderScreen({super.key, required this.user});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String status = "Loading...";
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  double totalprice = 0.0;
  List<Order> orderList = <Order>[];

  @override
  void initState() {
    super.initState();
    loadsellerorders();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title:
              const Text("Your Order", style: TextStyle(color: Colors.white))),
      body: Container(
        child: orderList.isEmpty
            ? Container()
            : Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: Row(
                        children: [
                          Flexible(
                              flex: 7,
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/images/profile2.png",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Hello ${widget.user.name}!",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          // Expanded(
                          //   flex: 3,
                          //   child: Row(children: [
                          //     IconButton(
                          //       icon: const Icon(Icons.notifications),
                          //       onPressed: () {},
                          //     ),
                          //     IconButton(
                          //       icon: const Icon(Icons.search),
                          //       onPressed: () {},
                          //     ),
                          //   ]),
                          // )
                        ],
                      ),
                    ),
                  ),
                  const Text("Your Current Order"),
                  Expanded(
                      child: ListView.builder(
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                  child: Text((index + 1).toString())),
                              title: const Text("Receipt: "),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Order ID: ${orderList[index].orderId}"),
                                        Text(
                                            "Status: ${orderList[index].orderStatus}"),
                                        Text(
                                            "Seller Phone: ${orderList[index].sellerPhone}"),
                                      ]),
                                  // const Column(
                                  //   children: [
                                  //     Text(
                                  //       "RM ",
                                  //       style: TextStyle(
                                  //           fontSize: 16,
                                  //           fontWeight: FontWeight.bold),
                                  //     ),
                                  //     Text("")
                                  //   ],
                                  // )
                                ],
                              ),
                            );
                          })),
                ],
              ),
      ),
    );
  }

  void loadsellerorders() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterlt/php/load_buyerorder.php"),
        body: {"buyerid": widget.user.id}).then((response) {
      log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          orderList.clear();
          var extractdata = jsondata['data'];
          extractdata['orders'].forEach((v) {
            orderList.add(Order.fromJson(v));
          });
        } else {
          status = "Please register an account first";
          setState(() {});
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "No order found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
        setState(() {});
      }
    });
  }
}
