import 'package:barberadminpanel/pages/homepage/home_page.dart';
import 'package:barberadminpanel/pages/services/firebase/login.dart';
import 'package:barberadminpanel/pages/widgets/elevated_button.dart';
import 'package:barberadminpanel/pages/widgets/text_field.dart';
import 'package:flutter/material.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  bool obscure = true;
  final TextEditingController _emailController =
      TextEditingController(text: 'sunny.kr117@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '12345678');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Admin Login!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: _emailController,
                hintText: "Email",
                prefixIcon: Icons.person,
                iconColor: Colors.white,
                textColor: Colors.white,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                prefixIcon: Icons.password,
                suffixIcon: obscure ? Icons.visibility_off : Icons.visibility,
                iconColor: Colors.white,
                textColor: Colors.white,
                onSuffixIconTap: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                obscureText: obscure,
              ),
              const SizedBox(height: 10),
              CustomElevatedButton(
                text: 'Log in',
                onPressed: () async {
                  await login(_emailController.text, _passwordController.text,
                      HomePage(), context);
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'User Login? ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Click Here',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 244, 202, 66),
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
