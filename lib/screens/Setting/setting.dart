import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:gfood_app/screens/Login/login.dart';
import 'package:gfood_app/components/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _userEmail = user?.email ??
        "Unknown User"; // This will provide a default value if email is null
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // This line makes the dialog box rounded.
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'About this app',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),
                const Text(
                    "We provide a user-friendly way to make the best choice for our customers when users are racking their brains de what they want to eat."), // Add the full description here.
                const SizedBox(height: 20),
                TextButton(
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 170),
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  _userEmail ?? 'Default Email',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(black),
            ),
            onPressed: () async {
              try {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: _userEmail);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'A password reset link has been sent to $_userEmail'),
                  ),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${error.toString()}'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Password'),
          ),

          const SizedBox(height: 20),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "About",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: black),
            title: const Text('About this app'),
            onTap: _showAboutDialog,
          ),

          //Others
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Others",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.report_problem_outlined, color: black),
            title: const Text('Report and Feedback'),
            onTap: () async {
              final TextEditingController feedbackController =
                  TextEditingController();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      bool isLoading = false;

                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        title: Text(
                          "Provide Feedback",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: feedbackController,
                            decoration: InputDecoration(
                              hintText: "Enter your feedback here",
                              filled: true,
                              fillColor: Colors.grey[100],
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: black, width: 1.5),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: black, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            maxLines: 4,
                          ),
                        ),
                        actions: [
                          if (isLoading) CircularProgressIndicator(),
                          if (!isLoading)
                            TextButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          if (!isLoading)
                            TextButton(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: black, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (feedbackController.text.isNotEmpty) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // Save to Firebase
                                  CollectionReference feedbacks =
                                      FirebaseFirestore.instance
                                          .collection('feedbacks');
                                  try {
                                    await feedbacks.add({
                                      'text': feedbackController.text,
                                      'timestamp': Timestamp.now(),
                                      // Optionally store user's UID
                                      // 'userId': FirebaseAuth.instance.currentUser?.uid,
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Feedback submitted!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Error submitting feedback!'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Feedback cannot be empty!'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            )
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: black),
            title: const Text('Sign Out'),
            onTap: () async {
              bool confirmed = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Sign Out'),
                        content:
                            const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  ) ??
                  false;

              if (confirmed) {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }
            },
          ),
        ],
      ),
    );
  }
}
