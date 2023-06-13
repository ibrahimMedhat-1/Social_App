import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/model/chat_user_model.dart';
import 'package:social_app/model/messageModel.dart';
import 'package:social_app/shared/constraints.dart';

class UserChatScreen extends StatelessWidget {
  final ChatUserModel? user;

  UserChatScreen(this.user, {super.key});

  static TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessages(user!.id);
      return BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              titleSpacing: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    // radius: 15,
                    backgroundImage: NetworkImage(user!.profileImage.toString()),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    user!.name.toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: ConditionalBuilder(
                condition: SocialCubit.get(context).message.isNotEmpty,
                builder: (context) => Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          if(index==SocialCubit.get(context).message.length){
                              return SizedBox(
                                height: 70,
                              );
                          }
                          if (uID == SocialCubit.get(context).message[index].senderId) {
                            return buildMyMessage(SocialCubit.get(context).message[index]);
                          }
                          else{
                            return buildMessageFromOtherUser(SocialCubit.get(context).message[index]);
                          }
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                        itemCount: SocialCubit.get(context).message.length+1,
                      ),
                    ),
                    textFormField(context),
                  ],
                ),
                fallback: (context) => const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildMessageFromOtherUser(MessageModel message) => Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
          child: Text(message.text.toString()),
        ),
      );

  Widget buildMyMessage(MessageModel message) => Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10))),
          child: Text(message.text.toString()),
        ),
      );

  Widget textFormField(context) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Write your message ...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      borderSide: BorderSide(color: Colors.grey)),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
                SocialCubit.get(context).sendMessage(receiverId: user!.id, text: messageController.text, dateTime: DateTime.now().toString());
              },
              height: 60,
              minWidth: 50,
              padding: EdgeInsets.zero,
              color: Colors.blue,
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            )
          ],
        ),
      );
}
