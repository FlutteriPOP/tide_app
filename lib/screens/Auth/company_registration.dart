import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/colors.dart';
import '../../services/api.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/textform.dart';
import '../../widgets/toast_widget.dart';

class CompanyRegistration extends StatefulWidget {
  const CompanyRegistration({super.key});

  @override
  State<CompanyRegistration> createState() => _CompanyRegistrationState();
}

class _CompanyRegistrationState extends State<CompanyRegistration> {
  String _employeeCount = 'Select Employee Count';
  String _workDays = 'Select Work Days';
  bool isClick = false;
  bool isLoading = false;

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  final FocusNode _companyNameFocusNode = FocusNode();
  final FocusNode _companyEmailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _ownerNameFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyEmailController.dispose();
    _phoneNumberController.dispose();
    _ownerNameController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    _radiusController.dispose();
    _companyNameFocusNode.dispose();
    _companyEmailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _ownerNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('_employeeCount: $_employeeCount');
    return Scaffold(
      backgroundColor: tTextwhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset('assets/images/login.png'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Company Registration',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: const Color(0xff0a5381)),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company Name',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      MyTextFormField(
                        controller: _companyNameController,
                        hintText: 'Enter Company Name',
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter company name';
                          }
                          return null;
                        },
                        focusNode: _companyNameFocusNode,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Company Email',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      MyTextFormField(
                        controller: _companyEmailController,
                        hintText: 'Enter Company Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter company email';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                        focusNode: _companyEmailFocusNode,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Company Phone Number',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      MyTextFormField(
                        controller: _phoneNumberController,
                        hintText: 'Enter Phone Number',
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter company phone number';
                          }
                          if (value.length != 10) {
                            return 'Please enter valid phone number';
                          }
                          return null;
                        },
                        focusNode: _phoneNumberFocusNode,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Owner Name',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      MyTextFormField(
                        controller: _ownerNameController,
                        hintText: 'Enter Your Name',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        focusNode: _ownerNameFocusNode,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Employees',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      CustomDropdown(
                        items: const [
                          '0-10',
                          '10-20',
                          '20-30',
                          '30-40',
                          '50+',
                        ],
                        selectedItem: _employeeCount,
                        onChanged: (value) {
                          setState(() {
                            _employeeCount = value;
                            log('_employeeCount: $_employeeCount');
                          });
                        },
                        dropdownContainerDecoration: BoxDecoration(
                          border: Border.all(color: tContainerColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Work Days',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      CustomDropdown(
                        items: const [
                          '4',
                          '5',
                          '6',
                        ],
                        selectedItem: _workDays,
                        onChanged: (value) {
                          setState(() {
                            _workDays = value;
                            log('_workDays: $_workDays');
                          });
                        },
                        dropdownContainerDecoration: BoxDecoration(
                          border: Border.all(color: tContainerColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: isClick,
                            onChanged: (value) {
                              setState(() {
                                isClick = value!;
                                log('isClick: $isClick');
                              });
                            },
                          ),
                          Text(
                            'Do You Want Location based Services?',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (isClick)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'Longitude',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            MyTextFormField(
                              hintText: 'Ex: 23.070XXXX',
                              controller: _longitudeController,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Latitude',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            MyTextFormField(
                              hintText: 'Ex: 72.517XXXX',
                              controller: _latitudeController,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Radius In Meters',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            MyTextFormField(
                              hintText: 'Enter Radius In Meters',
                              controller: _radiusController,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    await register();
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: tContainerColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: tTextwhiteColor)
                                : Text(
                                    'Register',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: tTextwhiteColor),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 20)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    try {
      if (isClick == true && _formKey.currentState!.validate()) {
        await ApiClient().postRegistration(
          companyName: _companyNameController.text,
          email: _companyEmailController.text,
          phone: _phoneNumberController.text,
          name: _ownerNameController.text,
          bandwidth: _employeeCount,
          workingDay: _workDays,
          radiusCheck: isClick,
          latitude: _latitudeController.text,
          longitude: _longitudeController.text,
          radiusRange: _radiusController.text,
        );
      } else if (isClick == false && _formKey.currentState!.validate()) {
        await ApiClient().postRegistration(
          companyName: _companyNameController.text,
          email: _companyEmailController.text,
          phone: _phoneNumberController.text,
          name: _ownerNameController.text,
          bandwidth: _employeeCount,
          workingDay: _workDays,
          radiusCheck: isClick,
        );
      } else {
        showToast('Somthing went wrong!');
      }

      log('_companyNameController.text: ${_companyNameController.text}');
      log('_companyEmailController.text: ${_companyEmailController.text}');
      log('_phoneNumberController.text: ${_phoneNumberController.text}');
      log('_ownerNameController.text: ${_ownerNameController.text}');
      log('_employeeCount: $_employeeCount');
      log('_workDays: $_workDays');
      log('isClick: $isClick');
      log('_latitude.text: ${_latitudeController.text}');
      log('_longitude.text: ${_longitudeController.text}');
      log('_radius.text: ${_radiusController.text}');
    } catch (e) {
      log(e.toString());
    }
  }
}