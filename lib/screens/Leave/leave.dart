import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipop_tracker/config/colors.dart';
import 'package:ipop_tracker/screens/Leave/pastleave.dart';
import 'package:ipop_tracker/screens/Leave/upcoming_leave.dart';
import 'package:ipop_tracker/widgets/circuler.dart';

import '../../services/api.dart';
import '../../widgets/leave.dart';
import 'add_leave.dart';

class LeavePage extends StatelessWidget {
  const LeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: tTextwhiteColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Leave',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => const AddLeave(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.add_box_outlined),
                          SizedBox(width: 5),
                          Text(
                            'Add Leave',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: ApiClient().getLeaveData('Past'),
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    final leave = snapshot.data;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: MyCircularIndicator(color: tsecondaryColor),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        color: tTextwhiteColor,
                        height: 150,
                        width: double.infinity,
                        child: const Center(
                          child: Text('Something went wrong'),
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            children: [
                              const CustomContainer(
                                leave: 'Leave',
                                leaveType: 'Balance',
                                leaveNumber: '0',
                                borderColor: tBorBlueColor,
                                countColor: tBorBlueColor,
                              ),
                              CustomContainer(
                                leave: 'Leave',
                                leaveType: 'Approved',
                                leaveNumber:
                                    (leave!.approvedCount ?? '0').toString(),
                                borderColor: tBorderLightGreenColor,
                                countColor: tBorderLightGreenColor,
                              ),
                              CustomContainer(
                                leave: 'Leave',
                                leaveType: 'Pending',
                                leaveNumber:
                                    (leave.pendingCount ?? '0').toString(),
                                borderColor: tBorderGreenColor,
                                countColor: tBorderGreenColor,
                              ),
                              CustomContainer(
                                leave: 'Leave',
                                leaveType: 'Cancelled',
                                leaveNumber:
                                    (leave.cancleCount ?? '0').toString(),
                                borderColor: tBorRedColor,
                                countColor: tBorRedColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: tTextwhiteColor,
                  ),
                  child: TabBar(
                    indicatorColor: tContainerColor,
                    labelColor: tTextwhiteColor,
                    unselectedLabelColor: tTextblackColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: tTextTrasparentColor,
                    overlayColor: WidgetStateProperty.all(tTextTrasparentColor),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: tContainerColor,
                    ),
                    tabs: const [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Past'),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                const Expanded(
                  child: TabBarView(
                    children: [
                      UpcomingLeave(),
                      PastLeave(),
                    ],
                  ),
                ),
                const SizedBox(height: 12)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
