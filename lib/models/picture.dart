import 'package:freezed_annotation/freezed_annotation.dart';

part 'picture.freezed.dart';

part 'picture.g.dart';

@freezed
class Picture with _$Picture {
  const factory Picture({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime? updatedAt,
    @JsonKey(name: 'promoted_at') required DateTime? promotedAt,
    required int width,
    required int height,
    required String color,
    @JsonKey(name: 'blur_hash') required String? blurHash,
    required String? description,
    @JsonKey(name: 'alt_description') required String altDescription,
    required Urls urls,
    required Links links,
    required int likes,
    @JsonKey(name: 'liked_by_user') required bool likedByUser,
    required User user,
  }) = Picture$;

  factory Picture.fromJson(Map<String, dynamic> json) => _$PictureFromJson(Map<String, dynamic>.from(json));
}

@freezed
class Urls with _$Urls {
  const factory Urls({
    required String raw,
    required String full,
    required String regular,
    required String small,
    required String thumb,
    @JsonKey(name: 'small_s3') required String smallS3,
  }) = Urls$;

  factory Urls.fromJson(Map<String, dynamic> json) => _$UrlsFromJson(Map<String, dynamic>.from(json));
}

@freezed
class Links with _$Links {
  const factory Links({
    required String self,
    required String html,
    required String download,
    @JsonKey(name: 'download_location') required String downloadLocation,
  }) = Links$;

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(Map<String, dynamic>.from(json));
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required String username,
    required String name,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String? lastName,
    @JsonKey(name: 'twitter_username') required String? twitterUsername,
    @JsonKey(name: 'portfolio_url') required String? portfolioUrl,
    required String? bio,
    required String? location,
    required UserLinks links,
    @JsonKey(name: 'profile_image') required ProfileImage profileImage,
    @JsonKey(name: 'instagram_username') required String? instagramUsername,
    @JsonKey(name: 'total_collections') required int totalCollections,
    @JsonKey(name: 'total_likes') required int totalLikes,
    @JsonKey(name: 'total_photos') required int totalPhotos,
    @JsonKey(name: 'accepted_tos') required bool acceptedTos,
    @JsonKey(name: 'for_hire') required bool forHire,
    required Social social,
  }) = User$;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(Map<String, dynamic>.from(json));
}

@freezed
class UserLinks with _$UserLinks {
  const factory UserLinks({
    required String self,
    required String html,
    required String photos,
    required String likes,
    required String portfolio,
    required String following,
    required String followers,
  }) = UserLinks$;

  factory UserLinks.fromJson(Map<dynamic, dynamic> json) => _$UserLinksFromJson(Map<String, dynamic>.from(json));
}

@freezed
class ProfileImage with _$ProfileImage {
  const factory ProfileImage({
    required String small,
    required String medium,
    required String large,
  }) = ProfileImage$;

  factory ProfileImage.fromJson(Map<dynamic, dynamic> json) => _$ProfileImageFromJson(Map<String, dynamic>.from(json));
}

@freezed
class Social with _$Social {
  const factory Social({
    @JsonKey(name: 'instagram_username') required String? instagramUsername,
    @JsonKey(name: 'portfolio_url') required String? portfolioUrl,
    @JsonKey(name: 'twitter_username') required String? twitterUsername,
    @JsonKey(name: 'paypal_email') required String? paypalEmail,
  }) = Social$;

  factory Social.fromJson(Map<dynamic, dynamic> json) => _$SocialFromJson(Map<String, dynamic>.from(json));
}
