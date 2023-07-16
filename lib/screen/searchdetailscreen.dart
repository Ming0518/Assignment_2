import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barterlt/item.dart';
import 'package:barterlt/user.dart';
import 'package:barterlt/myconfig.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ItemDetailsScreen extends StatefulWidget {
  final Item useritem;
  final User user;
  const ItemDetailsScreen(
      {super.key, required this.useritem, required this.user});

  @override
  State<ItemDetailsScreen> createState() => _SellerDetailsScreenState();
}

class _SellerDetailsScreenState extends State<ItemDetailsScreen> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');

  late double screenHeight, screenWidth, cardwitdh;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:
            const Text("Items Details", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.white, // Set the desired background color here
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Card(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        3, // Change the itemCount according to the number of pictures
                    itemBuilder: (context, index) {
                      return Container(
                        width: screenWidth,
                        child: CachedNetworkImage(
                          width: screenWidth,
                          fit: BoxFit.cover,
                          imageUrl:
                              "${MyConfig().SERVER}/barterlt/assets/items/${widget.useritem.itemId}_${index + 1}.png",
                          placeholder: (context, url) =>
                              const LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.useritem.itemName.toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Description : ${widget.useritem.itemDesc}",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "State \t\t\t\t\t\t\t\t\t\t\t: ${widget.useritem.itemState}",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Locality\t\t\t\t\t\t\t: ${widget.useritem.itemLocality}",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Condition\t\t\t\t: ${widget.useritem.itemValue}/10",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addtocartdialog();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Set the background color to green
              ),
              child: const Text(
                "BaeterIt Now",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addtocartdialog() {
    if (widget.user.id.toString() == widget.useritem.userId.toString()) {
      Fluttertoast.showToast(
          msg: "User cannot barter own item",
          backgroundColor: const Color.fromARGB(255, 126, 255, 186),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
          textColor: Colors.black);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Barter This Item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                addtocart();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addtocart() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/insert_cart.php"),
        body: {
          "item_id": widget.useritem.itemId,
          "userid": widget.user.id,
          "sellerid": widget.useritem.userId,
          "phone": widget.useritem.userPhone
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
