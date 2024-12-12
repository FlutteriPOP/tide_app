import 'dart:developer';

import 'package:flutter/material.dart';

import '../../config/colors.dart';
import '../../model/dashbord.dart';
import '../../model/holiday.dart';
import '../../services/api.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/holiday_container.dart';
import '../../widgets/loding.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  HolidayScreenState createState() => HolidayScreenState();
}

class HolidayScreenState extends State<HolidayScreen> {
  late Future<void> _fetchHolidayFuture;
  HolidayModel? holidayData;
  DashboardModel? dashboardFuture;
  bool isLoding = false;

  @override
  void initState() {
    super.initState();
    image();
    _fetchHolidayFuture = _fetchHolidayData();
  }

  Future<void> image() async {
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

  Future<void> _fetchHolidayData() async {
    try {
      final fetchedData = await ApiClient().getHolidayData();
      setState(() {
        holidayData = fetchedData;
        holidayData?.data.sort((a, b) {
          final dateA = _parseDate(a.holidayDate);
          final dateB = _parseDate(b.holidayDate);
          return dateA.compareTo(dateB);
        });
      });
    } catch (e) {
      debugPrint('Error fetching holiday data: $e');
    }
  }

  DateTime _parseDate(String? dateString) {
    if (dateString == null) return DateTime(0);
    final parts = dateString.split('-');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchHolidayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LodingPage(color: tsecondaryColor),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Failed to load holiday data',
              style: TextStyle(color: tBorRedColor),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: tTextwhiteColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    MyAppBar(
                      title: 'Holiday',
                      leadingIcon: Icons.arrow_back_ios_new,
                      trailingImage: dashboardFuture?.companyImage,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: holidayData?.data.length,
                        itemBuilder: (context, index) {
                          final holiday = holidayData!.data[index];
                          return HolidayContainer(
                            title: holiday.holidayTitle ?? '',
                            date: holiday.holidayDate ?? '',
                            day: holiday.holidayDay ?? '',
                            index: index,
                            imageUrl: holiday.holidayImage ?? '',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
