import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/colors.dart';
import '../../model/dashbord.dart';
import '../../model/policy.dart';
import '../../services/api.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/listitem.dart';
import '../../widgets/loding.dart';
import '../Auth/change_pass.dart';
import '../other/welcome_screen.dart';
import '../profile/edit_profile.dart';
import 'holiday.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isLoading = false;
  DashboardModel? _dashboardFuture;
  PolicyModel? _policyFutureData;

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
    _fetchPolicies();
  }

  Future<String?> _loadImageUrl() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('companyImageUrl');
    } catch (e) {
      log('Error loading image URL: $e');
      return null;
    }
  }

  Future<void> _fetchPolicies() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final dashboard = await ApiClient().getDashbordData();
      final policy = await ApiClient().getPolicyData();

      setState(() {
        _dashboardFuture = dashboard;
        _policyFutureData = policy;
        _isLoading = false;
      });
    } catch (e) {
      log('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LodingPage(
            color: tsecondaryColor,
          )
        : Scaffold(
            backgroundColor: tTextwhiteColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: MyAppBar(
                        title: 'Settings',
                        trailingImage: _dashboardFuture?.companyImage,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionDivider('ACCOUNT'),
                    const SizedBox(height: 5),
                    _buildProfileAndChangePasswordItems(),
                    const SizedBox(height: 5),
                    if (_policyFutureData?.data.isNotEmpty ?? false)
                      _buildSectionDivider('PREFERENCES'),
                    const SizedBox(height: 5),
                    _buildPolicyItems(),
                    const SizedBox(height: 10),
                    _buildLogoutButton(),
                    const SizedBox(height: 20),
                    const Text(
                      "Copyright @2024 iPOP Solutions LLP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
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
                              color: tBorBlueColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildSectionDivider(String title) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: tContainerColor,
            indent: 50,
            endIndent: 5,
            height: 1,
            thickness: 2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const Expanded(
          child: Divider(
            color: tContainerColor,
            endIndent: 50,
            indent: 5,
            height: 1,
            thickness: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAndChangePasswordItems() {
    return Column(
      children: [
        _buildListItem(
          leadingAsset: 'assets/icons/user.png',
          title: 'My Profile',
          onTap: () => Get.to(() => const EditProfile(),
              transition: Transition.rightToLeft),
        ),
        _buildListItem(
          leadingAsset: 'assets/icons/c-pass.png',
          title: 'Change Password',
          onTap: () => Get.to(() => const ChangePass(),
              transition: Transition.rightToLeft),
        ),
        _buildListItem(
          leadingAsset: 'assets/icons/holiday.png',
          title: 'Holiday',
          onTap: () => Get.to(() => const HolidayScreen(),
              transition: Transition.rightToLeft),
        ),
      ],
    );
  }

  Widget _buildPolicyItems() {
    return Column(
      children: _policyFutureData?.data.map((policy) {
            return _buildListItem(
              leadingAsset: 'assets/icons/privacy.png',
              title: policy.cmsPageTitle ?? '',
              onTap: () async {
                final url = policy.cmsFullUrl;
                await launchUrl(Uri.parse(url!));
              },
            );
          }).toList() ??
          [],
    );
  }

  Widget _buildListItem({
    required String leadingAsset,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: CustomListItem(
        leadingAsset: leadingAsset,
        title: title,
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () async => await _showLogoutDialog(),
      child: Container(
        height: 60,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: tContainerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'SIGN OUT',
            style: TextStyle(
                fontSize: 16,
                color: tTextwhiteColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: tContainerColor,
                ),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Container(
                decoration: BoxDecoration(
                  color: tContainerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: tTextwhiteColor,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.remove('token');
                await preferences.remove('permission');
                Get.offAll(() => const WelcomePage());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: tBorRedColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: tTextwhiteColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
