import 'package:barbershopapp/pages/HomePage/home.dart';
import 'package:barbershopapp/pages/signup_page.dart';
import 'package:barbershopapp/services/firebase/login.dart';
import 'package:barbershopapp/widgets/elevated_button.dart';
import 'package:barbershopapp/widgets/text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscure = true; // Moved outside build method
  final TextEditingController _emailController =
      TextEditingController(text: 'sunnykr1@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '123456789');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/BarberShopLogo.png",
              ),
              const SizedBox(height: 10),
              const Text(
                "Welcome You Have Been Missed!",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              CustomTextField(
                controller: _emailController,
                hintText: "Email",
                prefixIcon: Icons.person,
                iconColor: Colors.black, // Set icon color to black
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                prefixIcon: Icons.password,
                suffixIcon: obscure ? Icons.visibility_off : Icons.visibility,
                iconColor: Colors.black, // Set icon color to black
                onSuffixIconTap: () {
                  setState(() {
                    obscure = !obscure; // Toggle obscure state
                  });
                },
                obscureText: obscure,
              ),
              const SizedBox(height: 10),
              CustomElevatedButton(
                text: 'Log in',
                onPressed: () async {
                  await login(_emailController.text, _passwordController.text,
                      Home(), context);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Not yet registerd?',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Click Here',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 177, 144, 37),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
