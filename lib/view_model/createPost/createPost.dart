// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/social_cubit.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({Key? key}) : super(key: key);
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Post'),
            actions: [
              if (state is! SocialUploadingPost)
                TextButton(
                  onPressed: () async {
                    if (cubit.postImage != null) {
                      await cubit.uploadPostImage(
                        text: textController.text,
                        dateTime: DateTime.now().toString(),
                      );
                      cubit.posts = [];
                      cubit.removeImage();
                      Navigator.pop(context);
                    } else {
                      cubit.createNewPost(
                        text: textController.text,
                        dateTime: DateTime.now().toString(),
                      );
                      cubit.posts = [];
                      cubit.getPosts();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'POST',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              const SizedBox(
                width: 15,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: cubit.model != null ? NetworkImage(cubit.model!.profileImage.toString()) : const NetworkImage(''),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(cubit.model != null ? cubit.model!.name.toString() : ''),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: TextFormField(
                  controller: textController,
                  maxLines: 40,
                  decoration: const InputDecoration(border: InputBorder.none),
                )),
                if (cubit.postImage != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(fit: BoxFit.fill, image: FileImage(File(cubit.postImage.toString()))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CircleAvatar(
                          child: IconButton(
                              onPressed: () {
                                cubit.removeImage();
                              },
                              icon: const Icon(
                                Icons.close,
                              )),
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.photo,
                            color: Colors.blue,
                          ),
                          TextButton(
                            onPressed: () {
                              cubit.getPostImage();
                            },
                            child: const Text('add photo'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: TextButton(onPressed: () {}, child: const Text('#tags'))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
