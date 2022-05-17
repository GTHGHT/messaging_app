import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/account.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreensState();
}

class _RegisterScreensState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  int passwordCounter = 0;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Desain Ulang Bagian Register
    return Scaffold(
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width / 6) * 5,
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(hintText: "Username"),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width / 6) * 5,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(hintText: "Email"),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width / 6) * 5,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Password"),
                  style: Theme.of(context).textTheme.bodyMedium,
                  buildCounter: (
                    BuildContext context, {
                    required int currentLength,
                    required int? maxLength,
                    required bool isFocused,
                  }) {
                    return Text(
                      '$currentLength Karakter',
                    );
                  },
                ),
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width / 6) * 5,
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Konfirmasi Password"),
                  style: Theme.of(context).textTheme.bodyMedium,
                  buildCounter: (
                    BuildContext context, {
                    required int currentLength,
                    required int? maxLength,
                    required bool isFocused,
                  }) {
                    return Text(
                      '$currentLength Karakter',
                    );
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<AuthAccess>()
                        .register(
                          username: usernameController,
                          email: emailController,
                          password: passwordController,
                          confirmPassword: confirmPasswordController,
                          showSnackBar: (String message) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                              ),
                            );
                          },
                        )
                        .then(
                          (value) =>
                              Navigator.pushReplacementNamed(context, "/main"),
                        );
                  },
                  child: Text("Register"),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Kembali"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}