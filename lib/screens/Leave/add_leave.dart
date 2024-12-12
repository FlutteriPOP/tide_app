import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import DateFormat
import 'package:ipop_tracker/config/colors.dart';
import 'package:ipop_tracker/model/dashbord.dart';
import 'package:ipop_tracker/screens/other/home.dart';
import 'package:ipop_tracker/widgets/app_bar.dart';
import 'package:ipop_tracker/widgets/textform.dart';

import '../../services/api.dart';
import '../../widgets/buttion.dart';
import '../../widgets/circuler.dart';
import '../../widgets/toast_widget.dart';

class AddLeave extends StatefulWidget {
  const AddLeave({super.key}); // Fix the key parameter

  @override
  State<AddLeave> createState() => _AddLeaveState();
}

class _AddLeaveState extends State<AddLeave> {
  final TextEditingController leaveTypeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoding = false;
  bool isPressed = false;

  DashboardModel? dashboardModel;

  @override
  void initState() {
    super.initState();
    image();
  }

  Future<void> image() async {
    isPressed = true;
    try {
      final dashboard = await ApiClient().getDashbordData();

      setState(() {
        dashboardModel = dashboard;
        isPressed = false;
      });
    } catch (e) {
      log('Error fetching profile data: $e');
    }
  }

  @override
  void dispose() {
    leaveTypeController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tTextwhiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: MyAppBar(
                      title: 'Add Leave',
                      leadingIcon: Icons.arrow_back_ios,
                      trailingImage: dashboardModel?.companyImage,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter leave type';
                      }
                      return null;
                    },
                    controller: leaveTypeController,
                    label: 'Enter Leave Type',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () =>
                              _selectDate(context, startDateController),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select start date';
                              }
                              return null;
                            },
                            controller: startDateController,
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(FontAwesomeIcons.calendarDays),
                              labelText: 'Start Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            enabled: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, endDateController),
                          child: TextFormField(
                            enabled: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select end date';
                              }
                              if (startDateController.text.isNotEmpty &&
                                  endDateController.text.isNotEmpty) {
                                final formatter = DateFormat('dd-MM-yyyy');
                                final startDate =
                                    formatter.parse(startDateController.text);
                                final endDate = formatter.parse(value);
                                final endDateInput =
                                    formatter.parse(endDateController.text);
                                if (endDate.isBefore(startDate)) {
                                  return 'Correct End Date ';
                                }
                                if (endDate.isAfter(endDateInput)) {
                                  return 'End date must be before or equal to ${endDateInput.toString()}';
                                }
                              }
                              return null;
                            },
                            controller: endDateController,
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(FontAwesomeIcons.calendarDays),
                              labelText: 'End Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter reason';
                      }
                      return null;
                    },
                    controller: reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Enter Reason',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: tContainerColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Color(0xff67abdb)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _submitLeave(),
                    child: isLoding
                        ? const Center(
                            child: MyCircularIndicator(
                              color: tsecondaryColor,
                            ),
                          )
                        : const MyButton(
                            text: 'Submit',
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final formatter = DateFormat('dd-MM-yyyy'); // Use DateFormat
      final formattedDate =
          formatter.format(pickedDate); // Format the picked date

      log("Formatted date: $formattedDate");

      controller.text = formattedDate;
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    }
  }

  void _submitLeave() async {
    if (formKey.currentState!.validate()) {
      if (!isLoding) {
        setState(() {
          isLoding = true;
        });
      }

      try {
        final leaveType = leaveTypeController.text;
        final startDate = startDateController.text;
        final endDate = endDateController.text;
        final reason = reasonController.text;

        final api = ApiClient();
        // if (isLoding == true) return;
        await api.postLeave(
          leaveType: leaveType,
          startDate: startDate,
          endDate: endDate,
          reason: reason,
        );
        showToast('Leave added successfully!');
        Get.to(() => const HomeScreen());
      } catch (error) {
        showToast(
          error.toString(),
        );
        log(error.toString());
      }

      setState(() {
        isLoding = false;
      });
    }
  }
}
