import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipop_tracker/config/colors.dart';
import 'package:ipop_tracker/model/profile.dart';
import 'package:ipop_tracker/widgets/loding.dart';

import '../../services/api.dart';
import '../../widgets/buttion.dart';
import '../../widgets/textform.dart';
import '../../widgets/toast_widget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController role;
  ProfileModel? data;
  File? selectedImage;
  bool isLoading = false;
  String? profileImageUrl;

  final ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    role = TextEditingController();
    _fetchProfileData();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    role.dispose();
    super.dispose();
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final profile = await apiClient.getProfile();

      if (profile.data != null && profile.data!.isNotEmpty) {
        final user = profile.data!.first;
        profileImageUrl = user.profileImage ?? '';
        name.text = user.name ?? '';
        email.text = user.email ?? '';
        phone.text = user.phoneNumber?.toString() ?? '';
        role.text = user.designation ?? '';
      } else {
        showToast('Error fetching profile data');
        profileImageUrl = '';
      }

      setState(() {
        data = profile;
        isLoading = false;
      });
    } catch (e) {
      log('Error fetching profile data: $e');
      showToast('Error fetching profile data');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: LodingPage(
            color: tsecondaryColor,
          ))
        : Scaffold(
            backgroundColor: tTextwhiteColor,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: tTextwhiteColor,
              title: const Text('Edit Profile'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: tContainerColor,
                            width: 3,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            myDialog();
                          },
                          child: ClipOval(
                            child: CircleAvatar(
                              backgroundColor: tTextwhiteColor,
                              maxRadius: 50,
                              backgroundImage: selectedImage != null
                                  ? FileImage(selectedImage!) as ImageProvider?
                                  : profileImageUrl != null
                                      ? NetworkImage(profileImageUrl!)
                                      : null,
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 25,
                        left: -10,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: tContainerColor,
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: tTextwhiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        MyTextFormField(
                          controller: name,
                          label: 'Name',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextFormField(
                          controller: email,
                          label: 'Email',
                          readonly: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextFormField(
                          keyboardType: TextInputType.phone,
                          controller: phone,
                          label: 'Phone Number',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (!value.isPhoneNumber) {
                              return 'Please enter valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextFormField(
                          controller: role,
                          label: 'Role',
                          readonly: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            updateProfile();
                          },
                          child: const MyButton(text: 'Update'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  void myDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  clickImage();
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.camera_alt,
                    size: 40, color: tsecondaryColor),
                title: const Text('Take a Photo',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                onTap: () {
                  pickImage();
                  Navigator.pop(context);
                },
                leading:
                    const Icon(Icons.image, size: 40, color: tsecondaryColor),
                title: const Text('Choose from Gallery',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      final croppedFile = await cropImage(File(pickedImage.path));
      setState(() {
        selectedImage = croppedFile;
      });
    } else {
      showToast('No image selected');
    }
  }

  Future<void> clickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (pickedImage != null) {
      final croppedFile = await cropImage(File(pickedImage.path));
      setState(() {
        selectedImage = croppedFile;
      });
    } else {
      showToast('No image taken');
    }
  }

  Future<File?> cropImage(File pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    // Returning the edited/cropped image if available, otherwise the original image
    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return File(pickedFile.path);
    }
  }

  Future<void> updateProfile() async {
    if (name.text.isEmpty && phone.text.isEmpty) {
      showToast('No changes made');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String? newName = name.text.isNotEmpty ? name.text : null;
      String? newPhone = phone.text.isNotEmpty ? phone.text : null;
      String? newEmail = email.text.isNotEmpty ? email.text : null;
      File? newImage = selectedImage;

      if (newImage != null) {
        // If a new image is selected, upload it
        await apiClient.editProfileData(
          name: newName,
          phone: newPhone,
          email: newEmail,
          image: newImage,
          role: role.text,
        );
      } else {
        // If no new image is selected, update other fields only
        await apiClient.editProfileData(
          name: newName,
          phone: newPhone,
          email: newEmail,
          role: role.text,
        );
      }

      Get.back(result: true);
      showToast('Profile updated successfully');
    } catch (e) {
      showToast('Error updating profile');
      log('Error updating profile: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
