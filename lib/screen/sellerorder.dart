import 'dart:convert';
import 'dart:developer';
import 'package:barterlt/screen/sellerorderdetailscreen.dart';
import 'package:flutter/material.dart';
import '/order.dart';
import '/user.dart';
import 'package:http/http.dart' as http;
import '/myconfig.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SellerOrderScreen extends StatefulWidget {
  final User user;

  const SellerOrderScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SellerOrderScreen> createState() => _SellerOrderScreenState();
}

class _SellerOrderScreenState extends State<SellerOrderScreen> {
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
        title: const Text("Your Barter", style: TextStyle(color: Colors.white)),
      ),
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
                                const SizedBox(width: 8),
                                Text(
                                  "Hello ${widget.user.name}!",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Current Order:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orderList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            if (orderList[index].orderStatus == "Completed") {
                              Fluttertoast.showToast(
                                msg: "The item is trade completed.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                fontSize: 16.0,
                              );
                              return; // If the order status is "complete," return without navigating to the next screen.
                            }
                            Order myorder =
                                Order.fromJson(orderList[index].toJson());
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (content) => ConfirmScreen(
                                  user: widget.user,
                                  order: myorder,
                                ),
                              ),
                            );
                            loadsellerorders();
                          },
                          leading: CircleAvatar(
                            child: Text((index + 1).toString()),
                          ),
                          title: const Text("Receipt: "),
                          trailing: const Icon(Icons.arrow_forward),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Order ID: ${orderList[index].orderId}"),
                                  Text(
                                      "Status: ${orderList[index].orderStatus}"),
                                  Text(
                                      "Buyer Phone: ${orderList[index].buyerPhone}"),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void loadsellerorders() {
    http.post(
      Uri.parse("${MyConfig().SERVER}/barterlt/php/load_sellerorder.php"),
      body: {"sellerid": widget.user.id},
    ).then((response) {
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
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "No order available",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0,
          );
          // status = "Please register an account first";
          // setState(() {});
        }
        setState(() {});
      }
    });
  }
}
