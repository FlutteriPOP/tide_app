import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ipop_tracker/config/colors.dart';
import 'package:ipop_tracker/controller/location.dart';
import 'package:ipop_tracker/model/dashbord.dart';
import 'package:ipop_tracker/screens/Auth/login_screen.dart';
import 'package:ipop_tracker/services/api.dart';
import 'package:ipop_tracker/widgets/loding.dart';
import 'package:lottie/lottie.dart';

import '../../config/themes.dart';
import '../../widgets/check_in.dart';
import '../../widgets/toast_widget.dart';
import '../History/history.dart';

class DashBordPage extends StatefulWidget {
  const DashBordPage({super.key});

  @override
  State<DashBordPage> createState() => _DashBordPageState();
}

class _DashBordPageState extends State<DashBordPage> {
  final LocationController locationController = Get.find<LocationController>();

  DashboardModel? data;
  bool isLoading = true;

  Position? position = LocationController().currentPosition;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future fetchProfileData() async {
    try {
      final apiClient = ApiClient();
      final profile = await apiClient.getDashbordData();

      if (profile == null || profile.data.isEmpty) {
        showToast('Please login again.');
        Get.offAll(() => const LoginPage());
        return;
      }

      if (!mounted) return;

      setState(() {
        data = profile;
        isLoading = false;
      });
    } catch (e) {
      log('Error fetching profile data: $e');
      showToast('Please try again.');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);

    return Scaffold(
      backgroundColor: tprimaryColor,
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: LodingPage(
                  color: tsecondaryColor,
                ),
              )
            : RefreshIndicator(
                color: tsecondaryColor,
                backgroundColor: tTextwhiteColor,
                onRefresh: () => fetchProfileData(),
                child: _buildDashboardContent(context, formattedDate)),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, String formattedDate) {
    return Column(
      children: [
        const SizedBox(height: 5),
        _buildHeader(context, formattedDate),
        _buildGridView(),
        if (data?.data.first.birthdayNotice.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: tTextTrasparentColor,
              ),
              padding: const EdgeInsets.only(left: 20),
              child:
                  _buildBirthdayNoticeWidget(data!.data.first.birthdayNotice),
            ),
          )
        else
          const SizedBox(height: 10),
        _buildRecentActivityHeader(context),
        _buildRecentActivityList(context, formattedDate),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String formattedDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${data?.data.first.name}',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 21,
                    color: tsecondaryColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                formattedDate,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 14),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => showProfile(
                imageUrl: data?.data.first.profileImage ?? '',
              ),
            ),
            child: CircleAvatar(
              radius: 27,
              backgroundColor: const Color(0xFFF0F9FF),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: data?.data.first.profileImage ?? '',
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(
                    color: tContainerColor,
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error_outline_sharp,
                    color: tBorRedColor,
                  ),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showProfile({required String imageUrl}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        CustomCheckInCard(
          imageUrl: 'assets/icons/check-in.png',
          checkInStatus: 'Check In',
          checkInTime: data?.data.first.todayFirstCheckIn ?? '--:--',
          expectedTime: '10:00 AM',
          color: const Color(0xfff1f8ec),
        ),
        CustomCheckInCard(
          imageUrl: 'assets/icons/check-out.png',
          checkInTime: data?.data.first.todayLastCheckOut ?? '--:--',
          checkInStatus: 'Check Out',
          expectedTime: '07:00 PM',
          color: const Color(0xfffdeef3),
        ),
        CustomCheckInCard(
          imageUrl: 'assets/icons/work.png',
          checkInTime: data?.data.first.workingHours ?? '--:--',
          checkInStatus: 'Working Hrs',
          expectedTime: '8:00 hrs',
          color: const Color(0xfff2f0fe),
        ),
        CustomCheckInCard(
          imageUrl: 'assets/icons/break.png',
          checkInTime: data?.data.first.breakTime ?? '--:--',
          checkInStatus: 'Break Time',
          expectedTime: '1:00 hrs',
          color: const Color(0xfffceed3),
        ),
      ],
    );
  }

  Widget _buildRecentActivityHeader(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: tTextwhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          InkWell(
            onTap: () {
              Get.to(() => const HistoryPage(),
                  transition: Transition.rightToLeft);
            },
            child: const Text(
              'See More',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: tmSatoshi,
                fontSize: 14,
                color: tFontcolor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context, String formattedDate) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: tTextwhiteColor,
        child: ListView.builder(
          itemCount: data?.data.first.todayTracking.length ?? 0,
          itemBuilder: (context, index) {
            final todayTracking = data?.data.first.todayTracking;
            if (todayTracking == null || index >= todayTracking.length) {
              return const SizedBox();
            }
            final tracking = todayTracking[index];
            return ListTile(
              leading: tracking.usersHistoryType == 'Check IN'
                  ? CircleAvatar(
                      radius: 15,
                      backgroundColor: const Color(0xfff1f8ec),
                      child: Image.asset('assets/icons/check-in.png'),
                    )
                  : CircleAvatar(
                      radius: 15,
                      backgroundColor: const Color(0xfffdeef3),
                      child: Image.asset('assets/icons/check-out.png'),
                    ),
              title: Text(
                tracking.usersHistoryType ?? '',
                style: const TextStyle(fontSize: 16, fontFamily: tmSatoshi),
              ),
              trailing: Text(
                tracking.usersHistoryTime ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: tsecondaryColor,
                  fontFamily: tbSatoshi,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(formattedDate),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildBirthdayNoticeWidget(List<BirthdayNotice> birthdayNotice) {
  final itemCount = birthdayNotice.length;
  final pageController = PageController();
  int currentPage = 0;

  // ignore: unused_local_variable
  late Timer timer;
  void nextPage() {
    currentPage = (currentPage + 1) % itemCount;
    if (!pageController.hasClients) return;
    pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    nextPage();
  });

  return PageView.builder(
    itemCount: itemCount,
    controller: pageController,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      final birthday = birthdayNotice[index];
      return Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: tTextTrasparentColor,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: birthday.profileImg!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(
                    color: tContainerColor,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Happy Birthday',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  birthday.name ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            LottieBuilder.asset(
              'assets/Animation/birthday.json',
            ),
          ],
        ),
      );
    },
  );
}
