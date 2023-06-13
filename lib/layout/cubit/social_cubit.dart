import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/model/chat_user_model.dart';
import 'package:social_app/model/create_user_model.dart';
import 'package:social_app/model/postModel.dart';
import 'package:social_app/shared/constraints.dart';
import 'package:social_app/shared/local/CacheHelper.dart';
import 'package:social_app/view_model/chats/chat.dart';
import 'package:social_app/view_model/chats/user_chat_screen.dart';
import 'package:social_app/view_model/createPost/createPost.dart';
import 'package:social_app/view_model/homePage/homePage.dart';
import 'package:social_app/view_model/logInScreen/login_screen.dart';
import 'package:social_app/view_model/post/newPost.dart';
import 'package:social_app/view_model/settings/settings.dart';
import 'package:social_app/view_model/users/users.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../model/messageModel.dart';

part 'social_state.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitial());

  static SocialCubit get(context) => BlocProvider.of(context);
  List<Widget> body = [
    HomePage(),
    const ChatScreen(),
    const NewPostScreen(),
    const Users(),
    const SettingsScreen(),
  ];
  List<String> title = ['Home', 'Chats', 'Post', 'User', 'Settings'];
  String? profileImageUrl;
  String? coverImageUrl;
  int currentIndex = 0;
  CreateUserModel? model;
  File? coverImage;
  String? profileImage;
  ImagePicker picker = ImagePicker();

  void getData() async {
    await FirebaseFirestore.instance.collection('user').doc(uID).get().then((value) {
      model = CreateUserModel.fromJson(value.data());
      emit(SocialGetData());
    }).catchError((onError) {
      debugPrint(onError.toString());
      emit(SocialError());
    });
  }

  void changeIndex(index, context) {
    if (index == 1) {
      users = [];
      getAllUsers();
    }
    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (builder) => CreatePostScreen()));
      emit(SocialNewPost());
    } else {
      currentIndex = index;
      emit(SocialChangeIndex());
    }
  }

  Future<void> getCoverImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      coverImage = (File(pickedImage.path));
      uploadCoverImage();
      emit(SocialCoverImageSuccess());
    }
  }

  Future<void> getProfileImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage = pickedImage.path;
      uploadProfileImage();
      emit(SocialProfileImageSuccess());
    }
  }

  void uploadProfileImage() {
    firebase_storage.FirebaseStorage.instance.ref().child('user/profileImage/$uID').putFile(File(profileImage!)).then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        FirebaseFirestore.instance.collection('user').doc(uID).update({'profileImage': profileImageUrl});
        getData();
        debugPrint(profileImageUrl);
      });
    }).catchError((onError) {
      debugPrint('object');
      debugPrint(onError);
    });
  }

  void uploadCoverImage() {
    firebase_storage.FirebaseStorage.instance.ref().child('user/coverImage/$uID').putFile(coverImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        FirebaseFirestore.instance.collection('user').doc(uID).update({'coverImage': coverImageUrl});
        getData();
        debugPrint(coverImageUrl);
      });
    }).catchError((onError) {
      debugPrint('object');
      debugPrint(onError);
    });
  }

  void signOut(context) async {
    uID = null;
    await CacheHelper.removeData(key: 'uId');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => LogInScreen()));
    emit(SocialSignOut());
  }

  void updateUserData({
    required name,
    required bio,
    required phone,
  }) {
    FirebaseFirestore.instance.collection('user').doc(uID).update({
      'name': name,
      'bio': bio,
      'phone': phone,
    }).then((value) {
      getData();
    });
  }

  String? postImage;

  void removeImage() {
    postImage = null;
    emit(SocialRemovePostImage());
  }

  void getPostImage() async {
    var picker = ImagePicker();
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    postImage = pickedImage!.path;
    emit(SocialGetPostImage());
  }

  Future<void> uploadPostImage({
    required String text,
    required String dateTime,
  }) async {
    emit(SocialUploadingPost());
    await firebase_storage.FirebaseStorage.instance.ref().child('user/postImage/$uID/$postImage').putFile(File(postImage!)).then((value) {
      value.ref.getDownloadURL().then((value) {
        createNewPost(
          dateTime: dateTime,
          text: text,
          postImageSaved: value,
        ).then((value) {
          posts = [];
          getPosts();
        });
      });
    }).catchError((onError) {
      debugPrint('object');
      debugPrint(onError);
    });
  }

  Future<void> createNewPost({
    required String text,
    required String dateTime,
    String? postImageSaved,
  }) async {
    PostModel post = PostModel(
      name: model!.name,
      text: text,
      postImageSaved: postImageSaved,
      profileImage: model!.profileImage,
      dateTime: dateTime,
      uID: uID,
    );
    await FirebaseFirestore.instance.collection('post').add(post.toMap()).then((value) {});
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('post').get().then((value) {
      posts = [];
      postsId = [];
      likes = [];
      for (var element in value.docs) {
        element.reference.collection('like').get().then((value) {
          postsId.add(element.id);
          debugPrint(value.docs.length.toString());
          likes.add(value.docs.length);
          posts.add(PostModel.fromJson(element.data()));
          emit(SocialGetPostsSuccess());
        }).catchError((e) {});
      }
    }).catchError((onError) {
      debugPrint(onError);
      emit(SocialGetPostError());
    });
  }

  bool like = false;

  void likePost(postId) {
    FirebaseFirestore.instance.collection('post').doc(postId).collection('like').doc(uID).set({'like': like}).then((value) {
      posts = [];
      getPosts();
      emit(SocialLikePostSuccess());
    }).catchError((onError) {
      debugPrint(onError);
      emit(SocialLikePostError());
    });
  }

  List<ChatUserModel> users = [];

  void getAllUsers() {
    FirebaseFirestore.instance.collection('user').get().then((value) {
      for (var element in value.docs) {
        if (element.id != uID) {
          users.add(ChatUserModel.fromJson(element.data()));
        }
        emit(SocialGetAllUsersSuccess());
      }
    });
  }

  void sendMessage({required receiverId, required text, required dateTime}) {
    MessageModel message = MessageModel(
      senderId: uID,
      receiverId: receiverId,
      text: text,
      dateTime: dateTime,
    );
    UserChatScreen.messageController.text = '';
    emit(SocialSendMessageSuccess());

    FirebaseFirestore.instance
        .collection('user')
        .doc(uID)
        .collection('chat')
        .doc(receiverId)
        .collection('message')
        .add(message.toMap())
        .then((value) {

      emit(SocialSendMessageSuccess());
    }).catchError((onError) {
      emit(SocialSendMessageError());
    });
    FirebaseFirestore.instance
        .collection('user')
        .doc(receiverId)
        .collection('chat')
        .doc(uID)
        .collection('message')
        .add(message.toMap())
        .then((value) {
      emit(SocialSendMessageSuccess());
    }).catchError((onError) {
      emit(SocialSendMessageError());
    });
  }

  List<MessageModel> message = [];

  void getMessages(receiverId) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(uID)
        .collection('chat')
        .doc(receiverId)
        .collection('message')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      message = [];
      for (var element in event.docs) {
        message.add(MessageModel.fromJson(element.data()));
      }
      emit(SocialGetMessages());
    });
  }

  void setComment(postId,comment){
    FirebaseFirestore.instance
        .collection('post').
    doc(postId)
        .collection('comments')
        .doc(uID)
        .collection('comment')
        .add({'comment':comment})
        .then((value){
      emit(SocialSetCommentSuccess());
    }).catchError((onError){
      print(onError);
      emit(SocialSetCommentError());
    });
  }
  List<String> comments=[];
  void getComment(postId){
    FirebaseFirestore.instance
        .collection('post').
    doc(postId)
        .collection('comments')
        .doc(uID)
    .collection('comment')
        .get()
        .then((value){
          for (var element in value.docs) {
            comments.add(element.data()['comment']);
          }
      emit(SocialSetCommentSuccess());
    }).catchError((onError){
      debugPrint(onError);
      emit(SocialSetCommentError());
    });
  }
}
