import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/login_related_screens/authentication.dart';
import 'package:travel_app/screens/screens.dart';
import 'package:travel_app/components/components.dart';
import 'validators.dart';

class SignUpPage extends StatefulWidget {
  final Map<String, String> assets;
  const SignUpPage({super.key, required this.assets});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isObscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final bool success = await FirebaseAuthentication().signUp(
      context,
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<Widget>(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Sign up failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 180,
                child: Center(
                  child: widget.assets['sign_up_logo'] != null
                      ? CachedNetworkImage(
                          imageUrl: widget.assets['sign_up_logo'] ?? '',
                        )
                      : CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                ),
              ),
              TextForm(
                controller: _emailController,
                label: 'Email Address',
                hint: 'Enter your email address',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.emailValidator,
              ),
              const SizedBox(height: 10),

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

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
