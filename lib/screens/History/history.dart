import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ipop_tracker/config/colors.dart';
import 'package:ipop_tracker/model/dashbord.dart';
import 'package:ipop_tracker/model/history.dart';
import 'package:ipop_tracker/services/api.dart';
import 'package:ipop_tracker/widgets/loding.dart';

import '../../widgets/app_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DashboardModel? dashboardFuture;
  HistoryModel? historyFuture;
  String selectedValue = DateTime.now().month.toString().padLeft(2, '0');
  bool isLoding = false;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "01", child: Text("January")),
      const DropdownMenuItem(
        value: "02",
        child: Text("February"),
      ),
      const DropdownMenuItem(value: "03", child: Text("March")),
      const DropdownMenuItem(value: "04", child: Text("April")),
      const DropdownMenuItem(value: "05", child: Text("May")),
      const DropdownMenuItem(value: "06", child: Text("June")),
      const DropdownMenuItem(value: "07", child: Text("July")),
      const DropdownMenuItem(value: "08", child: Text("August")),
      const DropdownMenuItem(value: "09", child: Text("September")),
      const DropdownMenuItem(value: "10", child: Text("October")),
      const DropdownMenuItem(value: "11", child: Text("November")),
      const DropdownMenuItem(value: "12", child: Text("December")),
    ];
    return menuItems;
  }

  @override
  void initState() {
    super.initState();
    image();
    refreshHistory(selectedValue);
  }

  Future image() async {
    isLoding = true;
    try {
      final dashboard = await ApiClient().getDashbordData();

      setState(() {
        dashboardFuture = dashboard;
        isLoding = false;
      });
    } catch (e) {
      log('Error fetching profile data: $e');
    }
  }

  Future<void> refreshHistory(String month) async {
    try {
      isLoding = true;

      final history = await ApiClient().getHistory(selectedValue);

      setState(() {
        historyFuture = history;
        isLoding = false;
      });
    } catch (e) {
      // Log the error
      log('Error fetching profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    log('selectedValue: $selectedValue');
    return isLoding
        ? const Center(
            child: LodingPage(
              color: tsecondaryColor,
            ),
          )
        : Scaffold(
            backgroundColor: tTextwhiteColor,
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: MyAppBar(
                        title: 'History',
                        trailingImage: dashboardFuture?.companyImage),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xff2e6d94),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xff2e6d94),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xff2e6d94),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: tTextwhiteColor,
                      ),
                      dropdownColor: tTextwhiteColor,
                      value: selectedValue,
                      onChanged: (String? newValue) {
                        log('newValue: $newValue');

                        setState(() {
                          selectedValue = newValue!;
                        });
                        refreshHistory(newValue!);
                      },
                      items: dropdownItems,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.builder(
                        itemCount: historyFuture?.data.length,
                        itemBuilder: (context, index) {
                          final historyData = historyFuture?.data[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          historyData?.day ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                        ),
                                        Text(
                                          historyData?.date?.split("-")[0] ??
                                              '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                fontSize: 18,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: tHistorycolor,
                                        border: Border(
                                            left: BorderSide(
                                                color: tsecondaryColor,
                                                width: 10)),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Total Working Hours',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  historyData?.totalHours ??
                                                      '0 hrs',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: 90,
                                                  child: Card(
                                                    elevation: 0,
                                                    color: tTextwhiteColor,
                                                    surfaceTintColor:
                                                        tTextwhiteColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Check In',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                            textScaler:
                                                                TextScaler
                                                                    .noScaling,
                                                          ),
                                                          Text(
                                                            historyData
                                                                    ?.checkInTime ??
                                                                '',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 95,
                                                  child: Card(
                                                    elevation: 0,
                                                    color: tTextwhiteColor,
                                                    surfaceTintColor:
                                                        tTextwhiteColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Check Out',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                            textScaler:
                                                                TextScaler
                                                                    .noScaling,
                                                          ),
                                                          Text(
                                                            historyData
                                                                    ?.checkOutTime ??
                                                                '--:--',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  child: Card(
                                                    elevation: 0,
                                                    color: tTextwhiteColor,
                                                    surfaceTintColor:
                                                        tTextwhiteColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Break Time',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                            textScaler:
                                                                TextScaler
                                                                    .noScaling,
                                                          ),
                                                          Text(
                                                            historyData
                                                                    ?.breakTime ??
                                                                '--:--',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          );
  }
}
