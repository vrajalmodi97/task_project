import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/core/blocs/auth/auth_bloc.dart';
import 'package:task_project/core/blocs/auth/auth_event.dart';
import 'package:task_project/core/blocs/auth/auth_state.dart';
import 'package:task_project/core/blocs/services/shared_prefs.dart';
import 'package:task_project/screens/HomeScreen.dart';
import 'package:task_project/screens/RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // _emailController.text = "vrajal@raidlayer.com";
    // _passwordController.text = "Abc@1234";
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    context.read<AuthBloc>().add(LoginRequested(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Login to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      // decoration: InputDecoration(
                      //   labelText: 'Email',
                      //   border: OutlineInputBorder(),
                      //   prefixIcon: Icon(Icons.email),
                      // ),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .black87), // Border color when not focused
                        ),
                        prefixIcon: Icon(Icons.email), // Icon color
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .black87), // Border color when not focused
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    SharedPrefs().userId = state.user.id;
                    SharedPrefs().name = state.user.name;
                    SharedPrefs().emailId = state.user.email;
                    SharedPrefs().phoneNumber = state.user.phoneNumber;
                    SharedPrefs().walletBalance = state.user.walletBalance;
                    SharedPrefs().isLoggedIn = true;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is AuthLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Set primary color
                      foregroundColor: Colors.white, // Text color
                      minimumSize:
                          Size(double.infinity, 50), // Full-width button
                    ),
                    child: state is AuthLoading
                        ? CircularProgressIndicator()
                        : Text('Login'),
                  );
                },
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text(
                  "Don't have an account? Register",
                  style:
                      TextStyle(color: Colors.blueAccent), // Text color updated
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
