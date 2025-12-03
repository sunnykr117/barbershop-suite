import 'package:barbershopapp/pages/login_page.dart';
import 'package:barbershopapp/services/firebase/registration.dart';
import 'package:barbershopapp/widgets/elevated_button.dart';
import 'package:barbershopapp/widgets/text_field.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool obscure = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

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
              Image.asset("assets/images/SignuppageLogo.png"),
              const SizedBox(height: 10),
              const Text(
                "Fill all your details!",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              CustomTextField(
                controller: _emailController,
                hintText: "Email",
                prefixIcon: Icons.person,
                iconColor: Colors.black,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _nameController,
                hintText: "Name",
                prefixIcon: Icons.person,
                iconColor: Colors.black,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                prefixIcon: Icons.password,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _confirmpasswordController,
                hintText: "Confirm Password",
                prefixIcon: Icons.password,
                suffixIcon: obscure ? Icons.visibility_off : Icons.visibility,
                iconColor: Colors.black,
                onSuffixIconTap: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                obscureText: obscure,
              ),
              const SizedBox(height: 10),
              CustomElevatedButton(
                text: 'Sign Up',
                onPressed: () async {
                  await signup(
                    _nameController.text,
                    _emailController.text,
                    _passwordController.text,
                    _confirmpasswordController.text,
                    'users',
                    context,
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Click Here',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 149, 115, 2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
