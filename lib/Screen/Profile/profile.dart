import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  TextEditingController _nameController =
      TextEditingController(text: 'Ivan Hng'); // Replace with the user's name
  TextEditingController _emailController = TextEditingController(
      text: 'ivanh8@gmail.com'); // Replace with the user's email
  TextEditingController _ageController =
      TextEditingController(text: '22'); // Replace with the user's age
  TextEditingController _genderController =
      TextEditingController(text: 'Male'); // Replace with the user's gender
  TextEditingController _occupationController = TextEditingController(
      text: 'Student'); // Replace with the user's occupation

  GoogleMapController? _googleMapController;
  LatLng _userLocation =
      const LatLng(37.77483, -122.419416); // Replace with the user's location

  void _showUserLocation() {
    _googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _userLocation, zoom: 15),
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Profile content
              const SizedBox(height: 10),
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/images/profile.png'), // Replace with your own profile image
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _genderController,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _occupationController,
                decoration: const InputDecoration(
                  labelText: 'Occupation',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              Container(
                height: size.height * 0.4,
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _userLocation,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) =>
                      _googleMapController = controller,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleEditMode();
        },
        child: Icon(_isEditing ? Icons.check : Icons.edit),
      ),
    );
  }
}
