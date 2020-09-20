import 'package:p/models/BookOfTheMonthModel.dart';

const String ASSET_IMAGE_SPLASH_BACKGROUND = "assets/images/splash_bg.png";
const String ASSET_IMAGE_LOGO = 'assets/images/splash_logo.png';
const String ASSET_IMAGE_P2K_LOGO = 'assets/images/icon_p2k.png';
const String ASSET_IMAGE_P2K_TEXT = 'assets/images/preschool_text.png';
const String ASSET_IMAGE_OR = 'assets/images/or_logo.png';

const String DUMMY_PROFILE_PHOTO_URL =
    'https://firebasestorage.googleapis.com/v0/b/hidden-gems-e481d.appspot.com/o/Images%2FUsers%2FDummy%2FProfile.jpg?alt=media&token=99cd4cbd-7df9-4005-adef-b27b3996a6cc';
//todo: update this DUMMY_PROFILE_PHOTO_URL path.

String version;
String buildNumber;

const String ALGOLIA_APP_ID = 'UO39GB988T';
const String ALGOLIA_SEARCH_API_KEY = 'a2688a24cb08d1b78aae5dcde6f1d54f';

final List<BookOfTheMonthModel> BOOKS_OF_THE_MONTH = [
  BookOfTheMonthModel(
      title: 'Book 1',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
  BookOfTheMonthModel(
      title: 'Book 2',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
  BookOfTheMonthModel(
      title: 'Book 3',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
  BookOfTheMonthModel(
      title: 'Book 4',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
  BookOfTheMonthModel(
      title: 'Book 5',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
  BookOfTheMonthModel(
      title: 'Book 6',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
  BookOfTheMonthModel(
      title: 'Book 7',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
  BookOfTheMonthModel(
      title: 'Book 8',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
  BookOfTheMonthModel(
      title: 'Book 9',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
  BookOfTheMonthModel(
      title: 'Book 10',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
  BookOfTheMonthModel(
      title: 'Book 11',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
  BookOfTheMonthModel(
      title: 'Book 12',
      imgUrl:
          'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'),
];

enum PROFILE_TYPE {
  TEACHER,
  PARENT,
  ADMIN,
}

enum APP_PAGES {
  HOME,
  MY_PASSPORT,
  SETTINGS,
  BOOK_OF_THE_MONTH,
  VISIT_LOG,
  READ_LOG,
  ABOUT,
  ADMIN,
  EDIT_PROFILE
}

extension PROFILE_TYPE_EXTENSION on PROFILE_TYPE {
  String get name {
    switch (this) {
      case PROFILE_TYPE.TEACHER:
        return 'TEACHER';
      case PROFILE_TYPE.PARENT:
        return 'PARENT';
      case PROFILE_TYPE.ADMIN:
        return 'ADMIN';
      default:
        return null;
    }
  }
}
