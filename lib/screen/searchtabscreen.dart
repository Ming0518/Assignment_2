import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterlt/item.dart';
import 'package:barterlt/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterlt/myconfig.dart';
import 'searchdetailscreen.dart';

class SearchTabScreen extends StatefulWidget {
  final User user;
  const SearchTabScreen({super.key, required this.user});

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  String maintitle = "Buyer", result = "0";
  List<Item> itemList = <Item>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  TextEditingController searchController = TextEditingController();
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;

  @override
  void initState() {
    super.initState();
    loadItems(1);
    print("Buyer");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(maintitle, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {
                showsearchDialog();
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: itemList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 24,
                color: Colors.lightGreen,
                alignment: Alignment.center,
                child: Text(
                  "$result Item Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        itemList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onTap: () {
                                if (widget.user.id == "na") {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Please Login First To See The Items Details",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  Item useritem =
                                      Item.fromJson(itemList[index].toJson());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (content) => ItemDetailsScreen(
                                        user: widget.user,
                                        useritem: useritem,
                                      ),
                                    ),
                                  );
                                  loadItems(curpage);
                                }
                              },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${MyConfig().SERVER}/barterlt/assets/items/${itemList[index].itemId}_1.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Text(
                                    itemList[index].itemName.toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "Condition: ${double.parse(itemList[index].itemValue.toString()).toStringAsFixed(2)}/10.00",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "${itemList[index].itemState}, ${itemList[index].itemLocality}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ))),
              SizedBox(
                height: 40,
                child: Container(
                  color: const Color.fromARGB(255, 123, 238, 115),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      // Build the list for text buttons with scroll
                      if ((curpage - 1) == index) {
                        // Set current page number active
                        color = Colors.white;
                      } else {
                        color = Colors.black;
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextButton(
                          onPressed: () {
                            curpage = index + 1;
                            loadItems(index + 1);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent,
                            ),
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color, fontSize: 18),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ]),
    );
  }

  void loadItems(int pg) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/load_item.php"),
        body: {"pageno": pg.toString()}).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);

          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          result = jsondata['numberofresult'];

          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text(
            "Enter Items Name:",
            style: TextStyle(),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Items',
                    labelStyle: TextStyle(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {
                    String search = searchController.text;
                    searchItem(search);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Search"),
                ),
              ],
            ),
          ),
          // actions: <Widget>[
          //   TextButton(
          //     child: const Text(
          //       "Close",
          //       style: TextStyle(),
          //     ),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  void searchItem(String search) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/load_item.php"),
        body: {"search": search}).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });

          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }
}
