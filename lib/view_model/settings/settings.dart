import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/view_model/EditProfileScreen/EditProfileScreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  SocialCubit.get(context).model!.coverImage.toString(),
                                ),
                              )),
                        ),
                      ),
                      CircleAvatar(
                        radius: 63,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(SocialCubit.get(context).model!.profileImage.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  SocialCubit.get(context).model!.name.toString(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        height: 2,
                      ),
                ),
                Text(
                  SocialCubit.get(context).model!.bio.toString(),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        height: 2,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '100',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Post',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '256',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Photos',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '10k',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Followers',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '64',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Followings',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Add Photos'),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => EditProfileScreen()));
                        },
                        child: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
