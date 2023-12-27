import 'package:flutter/material.dart';
import 'package:gfood_app/components/constant.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:gfood_app/components/data/database/database_helper.dart';
import 'package:gfood_app/components/data/provider/database_provider.dart';
import 'package:gfood_app/components/data/provider/restaurant_provider.dart';
import 'package:gfood_app/components/data/services/api_services.dart';
import 'package:gfood_app/screens/mainframe.dart';
import 'package:provider/provider.dart';
import 'screens/Welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase app
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (context) =>
              DatabaseProvider(firestoreHelper: FirestoreHelper())),
      // Other providers if you have any
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RestaurantProvider(
            apiService: ApiService()), // Initialize your RestaurantProvider
        child: MaterialApp(
          debugShowCheckedModeBanner:
              false, // Set to false to remove the debug banner
          title: 'GFood App',
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data != null) {
                  // User is authenticated, navigate to home screen
                  return const MainFrame(
                    title: 'Home',
                  ); // Replace with your home screen
                } else {
                  // User is not authenticated, show welcome screen
                  return const WelcomeScreen();
                }
              }
              // Handle other connection states
              return CircularProgressIndicator();
            },
          ),
        ));
  }
}
