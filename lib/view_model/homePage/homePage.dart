import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/social_cubit.dart';
import '../../model/postModel.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
TextEditingController commentController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                if (FirebaseAuth.instance.currentUser!.emailVerified == false)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: const [
                          Icon(Icons.info),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Please verify your email'),
                        ]),
                        TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.currentUser!.sendEmailVerification();
                            },
                            child: const Text('send email'))
                      ],
                    ),
                  ),
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    if (SocialCubit.get(context).model != null)
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(SocialCubit.get(context).model!.coverImage.toString()),
                            )),
                      ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Text(
                        'communicate with friends',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                ConditionalBuilder(
                  condition: SocialCubit.get(context).posts.isNotEmpty && SocialCubit.get(context).model != null,
                  builder: (context) => ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) =>
                          widgetBuilder(context, SocialCubit.get(context).posts[index], SocialCubit.get(context).postsId[index], index),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 8,
                          ),
                      itemCount: SocialCubit.get(context).posts.length),
                  fallback: (context) => const Center(child: CircularProgressIndicator()),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget widgetBuilder(context, PostModel model, postId, index) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(offset: Offset(0, 0), blurRadius: 6, color: Colors.grey),
            ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: SocialCubit.get(context).model != null ? NetworkImage(model.profileImage.toString()) : const NetworkImage(''),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(model.name.toString()),
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                            Text(
                              model.dateTime.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                  ],
                ),
                const Divider(
                  thickness: 2,
                  height: 30,
                ),
                if (model.text != '')
                  Text(
                    model.text.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                // Container(
                //   margin: const EdgeInsets.symmetric(vertical: 10),
                //   width: double.infinity,
                //   child: Wrap(
                //     spacing: 10,
                //     alignment: WrapAlignment.start,
                //     children: [
                //       SizedBox(
                //         height: 20,
                //         child: MaterialButton(
                //             padding: EdgeInsets.zero,
                //             minWidth: 1,
                //             onPressed: () {},
                //             child: const Text(
                //               '#software',
                //               style: TextStyle(color: Colors.blue),
                //             )),
                //       ),
                //       SizedBox(
                //         height: 20,
                //         child: MaterialButton(
                //             padding: EdgeInsets.zero,
                //             minWidth: 1,
                //             onPressed: () {},
                //             child: const Text(
                //               '#software',
                //               style: TextStyle(color: Colors.blue),
                //             )),
                //       ),
                //       SizedBox(
                //         height: 20,
                //         child: MaterialButton(
                //             padding: EdgeInsets.zero,
                //             minWidth: 1,
                //             onPressed: () {},
                //             child: const Text(
                //               '#software',
                //               style: TextStyle(color: Colors.blue),
                //             )),
                //       ),
                //     ],
                //   ),
                // ),
                if (model.postImageSaved != null)
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          model.postImageSaved.toString(),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 30,
                            margin: EdgeInsets.zero,
                            child: MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: const Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Text(
                            '${SocialCubit.get(context).likes[index]}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 30,
                            margin: EdgeInsets.zero,
                            child: MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: const Icon(
                                Icons.comment,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          Text(
                            '0 comment',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        SocialCubit.get(context).model!.profileImage.toString(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: TextFormField(
                          controller: commentController,
                          onFieldSubmitted: (value){
                            SocialCubit.get(context).setComment(postId,value);
                            SocialCubit.get(context).getComment(postId);
                          },
                          decoration: InputDecoration(
                            hintText: 'Write your cpmment ...',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            )
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 30,
                      margin: EdgeInsets.zero,
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          SocialCubit.get(context).likePost(postId);
                        },
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Text(
                      'like',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
