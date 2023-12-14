import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/constants/color_constant.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/auth_repo.dart';
import 'package:whatsapp_clone/utills/snippets.dart';
import 'package:whatsapp_clone/views/home_view.dart';
import 'package:whatsapp_clone/views/widgets/custom_textfield.dart';
import 'package:whatsapp_clone/views/widgets/loader_button.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  File? image;

  void selectImage() async {
    image = await pickImage(context: context,imageSource: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your profile'),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  image == null
                      ? const CircleAvatar(
                          backgroundColor: greyColor,
                          radius: 64,
                          child: Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.black45,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(
                            image!,
                          ),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: tabColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: selectImage,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CustomTextfield(
                  hintText: 'Name',
                  controller: nameController,
                  prefixIcon: Icons.abc,
                  iconSize: 30),
              const SizedBox(height: 20),
              CustomTextfield(
                  hintText: 'Email',
                  controller: emailController,
                  prefixIcon: Icons.email,
                  iconSize: 25),
              const Spacer(),
              LoaderButton(
                  btnText: 'Save',
                  onTap: () async {
                    if (image == null) {
                      snack(context, 'Please select an image');
                      return;
                    }
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty) {
                      snack(context, 'Please Fill All Fields');
                      return;
                    }
                    try {
                      UserModel userModel = UserModel(
                        isOnline: true,
                        phone: '',
                        profilePic: '',
                        uid: '',
                        email: emailController.text,
                        name: nameController.text,
                        groupId: <String>[],
                      );
                      await AuthRepo.instance.saveUserDataToFirebase(
                          userModel: userModel, image: image!);
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeView()),
                          (route) => false);
                    } catch (e) {
                      snack(context, e.toString());
                    }
                  }),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
