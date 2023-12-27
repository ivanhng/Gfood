import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:gfood_app/screens/mainframe.dart';

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  bool isVegetarian = false;
  Set<String> selectedCuisines = {};
  String? budget;
  String? beverageFrequency;
  Set<String> diningPreferences = {};
  Set<String> dishPreferences = {};
  Set<String> selectedAtmosphere = {};
  Set<String> selectedDiningTypes = {};

  void storeUserPreferences() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('User not authenticated');
      return;
    }
    final collection =
        FirebaseFirestore.instance.collection('user_preferences');
    final userPreferences = {
      'isVegetarian': isVegetarian,
      'selectedCuisines': selectedCuisines.toList(),
      'budget': budget,
      'selectedAtmosphere': selectedAtmosphere.toList(),
      'selectedDiningTypes': selectedDiningTypes.toList(),
    };

    try {
      await collection.doc(userId).set(userPreferences);
      print('Preferences stored successfully');
    } catch (e) {
      print('Error storing preferences: $e');
    }
  }

  void _showMustAnswerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap a button to close the dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Important!'),
          content: Text(
              'Please answer the questionnaire before proceeding with the app.'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Understood',
                style: TextStyle(color: black),
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

  @override
  void initState() {
    super.initState();

    // Display the dialog
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _showMustAnswerDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        titleSpacing: 24.0,
        centerTitle: false,
        toolbarHeight: 96.0,
        backgroundColor: Colors.black,
        title: Text('Questionnaire', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(
            color: Colors
                .white), // Set the color for AppBar icons (like back arrow)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Are you vegetarian?
              Text('Are you vegetarian?'),
              RadioListTile(
                title: Text('Yes'),
                value: true,
                groupValue: isVegetarian,
                onChanged: (bool? value) {
                  setState(() {
                    isVegetarian = value!;
                  });
                },
              ),
              RadioListTile(
                activeColor: black,
                title: Text('No'),
                value: false,
                groupValue: isVegetarian,
                onChanged: (bool? value) {
                  setState(() {
                    isVegetarian = value!;
                  });
                },
              ),

              // Cuisines
              Divider(),
              Text('Choose your Favourite Cuisines'),
              ...[
                'Breakfast',
                'Lunch',
                'Brunch',
                'Dinner',
                'Chinese',
                'Rice',
                'Noodles',
                'Pasta',
                'Malay',
                'Indo',
                'Thai',
                'Japanese',
                'Beverages',
                'Burger',
                'Pizza',
                'Western',
                'Coffee',
                'Dessert',
                'Alcohol',
                'Beer',
                'Cocktails',
                'Dimsum',
                'Fast Food',
                'Pastries',
                'Late-night food',
                'Satay',
                'Salad',
                'Italian', // from your previous list
                'American' // from your previous list
              ].map((cuisine) {
                return CheckboxListTile(
                  activeColor: black,
                  checkColor: Colors.white,
                  title: Text(cuisine),
                  value: selectedCuisines.contains(cuisine),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedCuisines.add(cuisine);
                      } else {
                        selectedCuisines.remove(cuisine);
                      }
                    });
                  },
                );
              }).toList(),
              //Atmosphere
              Divider(),
              Text('Which atmosphere do you prefer when dining?'),
              ...['Casual', 'Cozy', 'Group'].map((atmosphere) {
                return CheckboxListTile(
                  activeColor: black,
                  checkColor: white,
                  title: Text(atmosphere),
                  value: selectedAtmosphere.contains(atmosphere),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedAtmosphere.add(atmosphere);
                      } else {
                        selectedAtmosphere.remove(atmosphere);
                      }
                    });
                  },
                );
              }).toList(),
              // Budget
              Divider(),
              Text('What\'s your typical budget for a meal?'),
              ...[
                {'label': 'Low Budget (1-10)', 'value': '1-10'},
                {'label': 'Medium (11-20)', 'value': '11-20'},
                {'label': 'High (>20)', 'value': '>20'}
              ].map((item) {
                return RadioListTile<String>(
                  activeColor: black,
                  title: Text(item['label']!),
                  value: item['value']!,
                  groupValue: budget,
                  onChanged: (String? value) {
                    setState(() {
                      budget = value;
                    });
                  },
                );
              }).toList(),
              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Button's background color
                  onPrimary: Colors.white, // Button's text color
                ),
                onPressed: () {
                  storeUserPreferences();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const MainFrame(
                          title: 'Home',
                        );
                      },
                    ),
                  );
                },
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white, // Set the scaffold's background color
    );
  }
}
