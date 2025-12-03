import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/components/components.dart';
import 'package:travel_app/provider/theme_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Profile',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: buildProfileCard(context),
                ),

                Divider(color: Theme.of(context).colorScheme.tertiary),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: buildSetYourPlaceUpCard(context),
                ),

                Divider(color: Theme.of(context).colorScheme.tertiary),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                SettingsTile(
                  icon: Icons.brightness_6,
                  title: 'Change Theme',
                  onTap: () {
                    ThemeProvider.of(context, listen: false).toggleTheme();
                  },
                ),
                Divider(color: Theme.of(context).colorScheme.tertiary),
                SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Personal information',
                  onTap: () {},
                ),
                Divider(color: Theme.of(context).colorScheme.tertiary),

                SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Login & security',
                  onTap: () {},
                ),
                Divider(color: Theme.of(context).colorScheme.tertiary),

                SettingsTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Payments and payouts',
                  onTap: () {},
                ),
                Divider(color: Theme.of(context).colorScheme.tertiary),

                SettingsTile(
                  icon: Icons.settings_accessibility,
                  title: 'Accessibility',
                  onTap: () {},
                ),
                Divider(color: Theme.of(context).colorScheme.tertiary),

                SettingsTile(
                  icon: Icons.security,
                  title: 'Get help with a safety issue',
                  onTap: () {},
                ),
                Divider(color: Theme.of(context).colorScheme.tertiary),
                SettingsTile(
                  icon: Icons.auto_awesome_outlined,
                  title: 'How this app works',
                  onTap: () {},
                ),
                Divider(color: Theme.of(context).colorScheme.tertiary),
                SettingsTile(
                  icon: Icons.edit_outlined,
                  title: 'Give us feedback',
                  onTap: () {},
                ),
                Divider(color: Theme.of(context).colorScheme.tertiary),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Legal',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                SettingsTile(
                  icon: Icons.menu_book_outlined,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
                Divider(color: Theme.of(context).colorScheme.tertiary),
                SettingsTile(
                  icon: Icons.menu_book_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                Divider(color: Theme.of(context).colorScheme.tertiary),
                SettingsTile(
                  icon: Icons.menu_book_outlined,
                  title: 'Open source licenses',
                  onTap: () {},
                ),
                Divider(color: Theme.of(context).colorScheme.tertiary),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        backgroundColor: Colors.red.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute<Widget>(
                        //     builder: (_) => const LoginPage(),
                        //   ),
                        // );
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildSetYourPlaceUpCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Set up your place for travel',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'It\'s simple to set up and start earning',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),

          Icon(
            Icons.house,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

Widget buildProfileCard(BuildContext context) {
  final User? user = FirebaseAuth.instance.currentUser;

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4)),
      ],
    ),
    child: Row(
      children: <Widget>[
        CircleAvatar(
          radius: 45,
          backgroundImage: CachedNetworkImageProvider(
            user?.photoURL ??
                "https://ui-avatars.com/api/?name=${user?.displayName ?? 'User'}",
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user?.displayName ?? 'User',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user?.email ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
