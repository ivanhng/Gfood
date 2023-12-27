import 'package:flutter/material.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:gfood_app/components/constant.dart';
import 'package:gfood_app/components/data/provider/restaurant_provider.dart';
import 'package:provider/provider.dart';

class FilterCriteria {
  Set<String> selectedCuisines;
  String? dietaryRequirement;
  String? selectedPriceRange;
  String? selectedAtmosphere;
  Set<String> selectedDiningTypes;

  FilterCriteria({
    required this.selectedCuisines,
    this.dietaryRequirement,
    this.selectedPriceRange,
    this.selectedAtmosphere,
    required this.selectedDiningTypes,
  });
}

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  Set<String> selectedCuisines = {};
  String? dietaryRequirement;
  String? mode;
  String? selectedPriceRange;
  String? selectedAtmosphere;
  Set<String> selectedDiningTypes = {};

  Widget buildDietarySection() {
    List<String> dietaryOptions = ['Vegetarian'];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dietaryOptions.length,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 1),
          child: CheckboxListTile(
            activeColor: Colors.black,
            checkColor: Colors.white,
            title: Text(
              dietaryOptions[index],
              style: TextStyle(color: Colors.black),
            ),
            value: dietaryRequirement == dietaryOptions[index],
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  dietaryRequirement = dietaryOptions[index];
                } else {
                  dietaryRequirement = null;
                }
              });
            },
            controlAffinity: ListTileControlAffinity
                .leading, // position checkbox on the left side
          ),
        );
      },
    );
  }

  Widget buildDiningTypeSection() {
    List<String> diningTypes = ['Outdoor seating', 'Dine-in', 'Takeaway'];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: diningTypes.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: CheckboxListTile(
            activeColor: Colors.black,
            title: Text(
              diningTypes[index],
              style: TextStyle(color: Colors.black),
            ),
            value: selectedDiningTypes.contains(diningTypes[index]),
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  selectedDiningTypes.add(diningTypes[index]);
                } else {
                  selectedDiningTypes.remove(diningTypes[index]);
                }
              });
            },
          ),
        );
      },
    );
  }

  Widget buildCuisinesSection() {
    List<String> cuisines = [
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
      'Desert',
      'Alcohol',
      'Beer',
      'Cocktails',
      'Dimsum',
      'Fast Food',
      'Patries',
      'Late-night food',
      'Satay',
      'Salad',
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cuisines.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: CheckboxListTile(
            activeColor: Colors.black,
            title: Text(
              cuisines[index],
              style: TextStyle(color: Colors.black),
            ),
            value: selectedCuisines.contains(cuisines[index]),
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  selectedCuisines.add(cuisines[index]);
                } else {
                  selectedCuisines.remove(cuisines[index]);
                }
              });
            },
          ),
        );
      },
    );
  }

  Widget buildActionButtons() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min, // This centers the buttons
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // Set button background to black
              onPrimary: Colors.white, // Set text color to white
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(25), // Set border radius here
              ),
            ),
            onPressed: () {
              // Logic for reset
              setState(() {
                selectedCuisines.clear();
                dietaryRequirement = null;
                mode = null;
                selectedPriceRange = null;
              });
            },
            child: Text('Reset'),
          ),
          SizedBox(width: 20), // Space between buttons
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // Set button background to black
              onPrimary: Colors.white, // Set text color to white
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(25), // Set border radius here
              ),
            ),
            onPressed: () {
              // Logic to apply filters
              FilterCriteria criteria = FilterCriteria(
                selectedCuisines: selectedCuisines,
                dietaryRequirement: dietaryRequirement,
                selectedPriceRange: selectedPriceRange,
                selectedAtmosphere: selectedAtmosphere,
                selectedDiningTypes: selectedDiningTypes,
              );

              // Now, pass the criteria to the RestaurantProvider to perform the filtering
              Provider.of<RestaurantProvider>(context, listen: false)
                  .filterRestaurants(criteria);

              // Close the FilterScreen
              Navigator.of(context).pop();
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget buildAtmosphereSection() {
    List<String> atmospheres = ['Casual', 'Cozy', 'Group'];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: atmospheres.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: RadioListTile<String>(
            activeColor: Colors.black,
            title: Text(
              atmospheres[index],
              style: TextStyle(color: Colors.black),
            ),
            value: atmospheres[index],
            groupValue: selectedAtmosphere,
            onChanged: (value) {
              setState(() {
                selectedAtmosphere = value;
              });
            },
          ),
        );
      },
    );
  }

  Widget buildPriceRangeSection() {
    List<Map<String, dynamic>> priceRanges = [
      {'label': 'Low Budget (1-10)', 'value': '1-10'},
      {'label': 'Medium (11-20)', 'value': '11-20'},
      {'label': 'High (>20)', 'value': '>20'}
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: priceRanges.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: RadioListTile<String>(
            activeColor: Colors.black,
            title: Text(
              priceRanges[index]['label'],
              style: TextStyle(color: Colors.black),
            ),
            value: priceRanges[index]['value'],
            groupValue: selectedPriceRange,
            onChanged: (value) {
              setState(() {
                selectedPriceRange = value;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 24.0,
        centerTitle: false,
        toolbarHeight: 96.0,
        backgroundColor: black,
        title: Text('Filters'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Card(
                color: Colors.black,
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.black,
                      title: Text(
                        'Dietary Requirements',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildDietarySection(),
                  ],
                ),
              ),
              Divider(color: Colors.grey, height: 20),
              Card(
                color: Colors.black,
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.black,
                      title: Text(
                        'Type of Dining',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildDiningTypeSection(),
                  ],
                ),
              ),
              Divider(color: Colors.grey, height: 20),
              Card(
                color: Colors.black,
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.black,
                      title: Text(
                        'Cuisines',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildCuisinesSection(),
                  ],
                ),
              ),
              Divider(color: Colors.grey, height: 20),
              Card(
                color: Colors.black,
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.black,
                      title: Text(
                        'Mode',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildAtmosphereSection(),
                  ],
                ),
              ),
              Divider(color: Colors.grey, height: 20),
              Card(
                color: Colors.black,
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.black,
                      title: Text(
                        'Budget',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildPriceRangeSection(),
                  ],
                ),
              ),
              Divider(color: Colors.grey, height: 20),
              buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
