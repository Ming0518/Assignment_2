import 'package:flutter/material.dart';
import 'package:barterlt/user.dart';
import 'package:barterlt/screen/editprofile.dart';
import 'package:barterlt/loginscreen.dart';

class RateTabScreen extends StatefulWidget {
  final User user;
  const RateTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<RateTabScreen> createState() => _RateTabScreenState();
}

class _RateTabScreenState extends State<RateTabScreen> {
  String maintitle = "Profile";
  late List<Widget> tabchildren;
  late double screenHeight, screenWidth, cardwitdh;

  @override
  void initState() {
    super.initState();
    print("Rate");
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(maintitle, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: screenHeight * 0.25,
            width: screenWidth,
            child: Card(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  width: screenWidth * 0.4,
                  child: Image.asset(
                    "assets/images/profile2.png",
                  ),
                ),
                Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        widget.user.name.toString() == "na"
                            ? const Column(
                                children: [
                                  Text(
                                    "Not Available",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Divider(),
                                  Text("Not Available"),
                                  Text("Not Available"),
                                  Text("Not Available"),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    widget.user.name.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const Divider(),
                                  Text("Email: ${widget.user.email}"),
                                  Text("Phone: ${widget.user.phone}"),
                                  Text(
                                      "Date Reg: ${widget.user.datereg.toString().substring(0, 10)}"),
                                ],
                              )
                      ],
                    )),
              ]),
            ),
          ),
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            color: const Color.fromARGB(255, 137, 246, 127),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
              child: Text("PROFILE SETTINGS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              const Divider(),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => EditProfileScreen(
                                user: widget.user,
                                onUpdateProfile: updateUserProfile,
                              )));
                },
                //color: Color.fromARGB(255, 176, 251, 217),
                child: const Text("EDIT PROFILE"),
              ),
              const Divider(),
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) => LoginScreen(
                                user: widget.user,
                              )));
                },
                //color: Colors.green,
                child: const Text("LOGIN"),
              ),
              const Divider(),
              MaterialButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => LoginScreen(
                                            user: widget.user,
                                          )));
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                //color: Colors.green,
                child: const Text("LOGOUT"),
              ),
              const Divider(),
            ],
          ))
        ]),
      ),
    );
  }

  void updateUserProfile(User updatedUser) {
    setState(() {
      // Update the user object or store it in a state management solution
      // Example:
      widget.user.name = updatedUser.name;
      widget.user.phone = updatedUser.phone;
      widget.user.password = updatedUser.password;
    });
  }
}
