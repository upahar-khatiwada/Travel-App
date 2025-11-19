import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/components/components.dart';
import 'package:travel_app/screens/login_related_screens/authentication.dart';
import 'package:travel_app/screens/login_related_screens/load_login_assets.dart';
import 'package:travel_app/screens/screens.dart';
import 'package:travel_app/screens/login_related_screens/validators.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  Map<String, String> _assets = <String, String>{};
  bool _isObscureText = true;
  bool _isLoading = false;
  bool _isLoadingGoogle = false;

  @override
  void initState() {
    super.initState();
    _loadAssets();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loadAssets() async {
    final Map<String, String> assets = await AppAssets().fetchAuthAssets();
    if (!mounted) return;
    setState(() {
      _assets = assets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: UnFocusOnTap(
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 20),

                            Text(
                              'Sign In to Travel App',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(
                              height: 180,
                              child:
                                  _assets['login_logo'] != null &&
                                      _assets['login_logo']!.isNotEmpty
                                  ? Center(
                                      child: CachedNetworkImage(
                                        imageUrl: _assets['login_logo'] ?? '',
                                        errorWidget: (_, __, ___) =>
                                            const Icon(Icons.error),
                                      ),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                            ),

                            // EMAIL TEXT
                            TextForm(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'Enter your email address',
                              prefixIcon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.emailValidator,
                            ),

                            const SizedBox(height: 15),

                            // PASSWORD TEXT
                            TextForm(
                              controller: _passwordController,
                              label: 'Password',
                              hint: 'Enter your password',
                              obscureText: _isObscureText,
                              prefixIcon: Icons.password,
                              suffixIcon: _isObscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              onSuffixTap: () {
                                setState(() {
                                  _isObscureText = !_isObscureText;
                                });
                              },
                              validator: Validators.passwordValidator,
                            ),

                            const SizedBox(height: 10),

                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<Widget>(
                                      builder: (_) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        setState(() {
                                          _isLoading = true;
                                        });

                                        final bool success =
                                            await FirebaseAuthentication()
                                                .signIn(
                                                  context,
                                                  _emailController.text.trim(),
                                                  _passwordController.text
                                                      .trim(),
                                                );

                                        setState(() {
                                          _isLoading = false;
                                        });

                                        if (success) {
                                          if (!context.mounted) return;
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute<Widget>(
                                              builder: (_) =>
                                                  const HomeScreen(),
                                            ),
                                          );
                                        } else {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Login failed. Check email and password.',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.inversePrimary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // DIVIDER
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // CONTINUE WITH GOOGLE
                            GestureDetector(
                              onTap: _isLoadingGoogle
                                  ? null
                                  : () async {
                                      if (!mounted) return;
                                      setState(() => _isLoadingGoogle = true);

                                      final UserCredential? credential =
                                          await FirebaseAuthentication()
                                              .signInWithGoogle(context);
                                      if (!mounted) return;
                                      setState(() => _isLoadingGoogle = false);

                                      if (credential == null) {
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Google sign-in failed',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      if (!context.mounted) return;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute<Widget>(
                                          builder: (_) => const HomeScreen(),
                                        ),
                                      );
                                    },
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: _isLoadingGoogle
                                      ? const CircularProgressIndicator()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            _assets['google_logo'] != null &&
                                                    _assets['google_logo']!
                                                        .isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        _assets['google_logo'] ??
                                                        '',
                                                    errorWidget: (_, __, ___) =>
                                                        const Icon(Icons.error),
                                                    height: 24,
                                                    width: 24,
                                                  )
                                                : const Icon(Icons.login),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Continue with Google',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // SIGN UP
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) =>
                            SignUpPage(assets: _assets),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
}
