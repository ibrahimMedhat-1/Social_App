import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/view_model/chats/user_chat_screen.dart';
import '../../layout/cubit/social_cubit.dart';
import '../../model/chat_user_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: ConditionalBuilder(
              condition: SocialCubit.get(context).users.isNotEmpty,
              builder: (context) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => chatUser(context, SocialCubit.get(context).users[index]),
                  separatorBuilder: (context, index) => const Divider(
                        height: 50,
                      ),
                  itemCount: SocialCubit.get(context).users.length),
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget chatUser(context, ChatUserModel model) => InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => UserChatScreen(model)));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(model.profileImage.toString()),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(model.name.toString()),
            ),
          ],
        ),
      );
}
