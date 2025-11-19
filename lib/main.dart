import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travel_app/provider/favorite_provider.dart';
import 'package:travel_app/provider/tabs_selected_provider.dart';
// import 'package:travel_app/firebase_upload/places_upload.dart';
import 'package:travel_app/screens/screens.dart';
import 'package:travel_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<FavoriteProvider>(
          create: (BuildContext context) => FavoriteProvider(),
        ),
        ChangeNotifierProvider<TabsSelectedProvider>(
          create: (BuildContext context) => TabsSelectedProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Travel App',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        // home: const UploadToFirebase(),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            } else if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}

// // Temporary
// class UploadToFirebase extends StatelessWidget {
//   const UploadToFirebase({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             savePlacesToFirebase();
//           },
//           child: const Text('Upload Places'),
//         ),
//       ),
//     );
//   }
// }
