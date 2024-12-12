import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ipop_tracker/screens/Auth/forgot_screen.dart';
import 'package:ipop_tracker/screens/other/home.dart';
import 'package:ipop_tracker/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/colors.dart';
import '../../widgets/toast_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isHidden = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tTextwhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/images/login.png'),
                ),
                const SizedBox(height: 30),
                Text(
                  'Employee Login',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: const Color(0xff0a5381), fontSize: 28),
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildForm(),
                _buildForgotPasswordButton(),
                const SizedBox(height: 5),
                _buildSignInButton(),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        const url =
                            'https://codegarage.in/track-tide/privacy-policy';
                        await launchUrl(Uri.parse(url));
                      },
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 14,
                          color: tTextBlueColor,
                        ),
                      ),
                    ),
                    const Text(' | '),
                    GestureDetector(
                      onTap: () async {
                        const url =
                            'https://codegarage.in/track-tide/terms-and-conditions';
                        await launchUrl(Uri.parse(url));
                      },
                      child: const Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontSize: 14,
                          color: tTextBlueColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: AutofillGroup(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Mail Id'),
            const SizedBox(height: 5),
            _buildEmailField(),
            const SizedBox(height: 10),
            _buildLabel('Password'),
            const SizedBox(height: 5),
            _buildPasswordField(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      focusNode: emailFocus,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => emailFocus.nextFocus(),
      autofillHints: const [AutofillHints.email],
      validator: _validateEmail,
      decoration: _inputDecoration(hintText: 'Email Address'),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      autofillHints: const [AutofillHints.password],
      obscureText: isHidden,
      focusNode: passwordFocus,
      textInputAction: TextInputAction.done,
      onEditingComplete: () {
        passwordFocus.unfocus();
        _signIn();
      },
      validator: _validatePassword,
      decoration: _inputDecoration(
        hintText: 'Password',
        suffixIcon: GestureDetector(
          onTap: togglePasswordView,
          child: Icon(
            isHidden ? Icons.visibility : Icons.visibility_off,
            color: tsecondaryColor,
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Your email address';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  InputDecoration _inputDecoration(
      {required String hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: tContainerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Color(0xff67abdb)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildForgotPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Get.to(() => const ForgetPage());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              'Forgot Password ?',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: isLoading ? null : _signIn,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: tContainerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: tTextwhiteColor,
                )
              : Text('Login',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: tTextwhiteColor)),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final apiClient = ApiClient();
        final loginResult = await apiClient.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (loginResult.message != null && loginResult.status == 'success') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', loginResult.data.first.token ?? '');
          await prefs.setString(
              'permission', loginResult.locationPermission.toString());

          log(loginResult.data.first.token ?? 'No token found');
          showToast(
            'Login Successful.',
          );
          Get.offAll(() => const HomeScreen());
        } else if (loginResult.status == 'fail') {
          showToast(loginResult.message ?? "Unknown error");
          log('Login failed: ${loginResult.message ?? "Unknown error"}');
        }
      } catch (error) {
        Fluttertoast.showToast(msg: error.toString());
        log('Error during login.');
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  void togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }
}
