import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../config/colors.dart';
import '../../services/auth.dart';
import '../../widgets/buttion.dart';
import '../../widgets/circuler.dart';
import '../../widgets/textform.dart';
import '../other/done_page.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => ChagePassPageState();
}

class ChagePassPageState extends State<ChangePass> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController samepasswordController = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode passwordFocus = FocusNode();
  FocusNode newpasswordFocus = FocusNode();
  FocusNode samepasswordFocus = FocusNode();
  bool isHidden = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    passwordController.dispose();
    newpasswordController.dispose();
    samepasswordController.dispose();
    passwordFocus.dispose();
    newpasswordFocus.dispose();
    samepasswordFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tTextwhiteColor,
      appBar: AppBar(
        backgroundColor: tTextwhiteColor,
        shadowColor: tTextwhiteColor,
        surfaceTintColor: tTextwhiteColor,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              'assets/images/icon.png',
              height: 100,
              width: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        MyTextFormField(
                          controller: passwordController,
                          focusNode: passwordFocus,
                          obscureText: isHidden,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: togglePasswordView,
                            icon: Icon(
                              isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: tsecondaryColor,
                            ),
                          ),
                          hintText: 'Enter Old Password',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextFormField(
                          controller: newpasswordController,
                          focusNode: newpasswordFocus,
                          obscureText: isHidden,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }

                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: togglePasswordView,
                            icon: Icon(
                              isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: tsecondaryColor,
                            ),
                          ),
                          hintText: 'Enter New Password',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextFormField(
                          controller: samepasswordController,
                          focusNode: samepasswordFocus,
                          obscureText: isHidden,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (newpasswordController.text.trim() !=
                                samepasswordController.text.trim()) {
                              return 'Password does not match';
                            }

                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: togglePasswordView,
                            icon: Icon(
                              isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: tsecondaryColor,
                            ),
                          ),
                          hintText: 'Confirm New Password',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: _changePassword,
                    child: isLoading
                        ? const MyCircularIndicator(
                            color: tsecondaryColor,
                          )
                        : const MyButton(
                            text: 'Change Password',
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
    );
  }

  Future<void> _changePassword() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final auth = PassAuth();
        final result = await auth.changePassword(
            oldPassword: passwordController.text.trim(),
            newPassword: newpasswordController.text.trim());
        if (result['status'] == 'success') {
          Get.off(() => const DonePage(
                mainText: 'Password Changed Successfully',
                subText: 'Please Login Again to Continue',
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

  void togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }
}
