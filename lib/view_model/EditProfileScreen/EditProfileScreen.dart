// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/cubit/social_cubit.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        nameController.text = SocialCubit.get(context).model!.name.toString();
        bioController.text = SocialCubit.get(context).model!.bio.toString();
        phoneController.text = SocialCubit.get(context).model!.phone.toString();
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit Profile"),
            actions: [
              TextButton(
                onPressed: () {
                  cubit.updateUserData(
                    name: nameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 250,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 250,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: cubit.model != null
                                            ? NetworkImage(SocialCubit.get(context).model!.coverImage.toString())
                                            : FileImage(cubit.coverImage!) as ImageProvider,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: IconButton(
                                      onPressed: () {
                                        cubit.getCoverImage();
                                      },
                                      icon: const Icon(
                                        Icons.camera,
                                        size: 40,
                                        color: Colors.blue,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 63,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: cubit.profileImage != null
                                    ? NetworkImage(SocialCubit.get(context).model!.profileImage.toString())
                                    : FileImage(File(cubit.profileImage.toString())) as ImageProvider,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  cubit.getProfileImage();
                                },
                                icon: const Icon(
                                  Icons.camera,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                                padding: EdgeInsets.zero),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.center,
                      controller: nameController,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      controller: bioController,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      controller: phoneController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
