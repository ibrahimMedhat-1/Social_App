part of 'social_cubit.dart';

@immutable
abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialChangeIndex extends SocialState {}

class SocialNewPost extends SocialState {}

class SocialGetData extends SocialState {}

class SocialError extends SocialState {}

class SocialProfileImageSuccess extends SocialState {}

class SocialProfileImageError extends SocialState {}

class SocialCoverImageSuccess extends SocialState {}

class SocialCoverImageError extends SocialState {}

class SocialSignOut extends SocialState {}

class SocialRemovePostImage extends SocialState {}

class SocialGetPostImage extends SocialState {}

class SocialGetPostsSuccess extends SocialState {}

class SocialGetPostError extends SocialState {}

class SocialUploadingPost extends SocialState {}

class SocialLikePostSuccess extends SocialState {}

class SocialLikePostError extends SocialState {}

class SocialGetAllUsersSuccess extends SocialState {}

class SocialSendMessageSuccess extends SocialState {}

class SocialSendMessageError extends SocialState {}

class SocialGetMessages extends SocialState {}
class SocialSetCommentSuccess extends SocialState {}
class SocialSetCommentError extends SocialState {}
