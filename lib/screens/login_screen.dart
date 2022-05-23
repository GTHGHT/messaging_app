import 'package:flutter/material.dart';
import 'package:messaging_app/services/auth_access.dart';
import 'package:provider/provider.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({Key? key}) : super(key: key);

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int passwordCounter = 0;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Desain Ulang Bagian Login
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
                height: 50,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<AuthAccess>()
                        .login(
                          email: emailController,
                          password: passwordController,
                          showSnackBar: (String message) {
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                ),
                              );
                          },
                        )
                        .then((value) {
                      if (value) {
                        Navigator.of(context).pushReplacementNamed("/main");
                      }
                    });
                  },
                  child: Text("Login"),
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