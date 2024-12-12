import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/colors.dart';
import '../../services/auth.dart';
import '../../widgets/buttion.dart';
import '../../widgets/circuler.dart';
import '../../widgets/textform.dart';
import '../other/done_page.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  TextEditingController forgetPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    forgetPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tTextwhiteColor,
      appBar: AppBar(
        backgroundColor: tTextTrasparentColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Image.asset(
                'assets/images/icon.png',
                height: 200,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  children: [
                    Text('Forgot Password ?',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: tsecondaryColor)),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                      child: MyTextFormField(
                        controller: forgetPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Email Address';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please Enter a Valid Email Address';
                          }
                          return null;
                        },
                        hintText: 'Enter Email Address',
                        prefixIcon: Icons.email_outlined,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: _resetPassword,
                      child: isLoading
                          ? const MyCircularIndicator(
                              color: tsecondaryColor,
                            )
                          : const MyButton(
                              text: 'Reset Password',
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final auth = PassAuth();
        final result =
            await auth.forgotPassword(forgetPasswordController.text.trim());
        if (result['status'] == 'success') {
          Get.off(() => const DonePage(
                mainText: 'Email Sent Successfully ',
                subText: 'Please check your email to reset your password.',
              ));
        }
      } catch (error) {
        debugPrint('Error resetting password: $error');
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}
