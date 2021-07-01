import 'package:p/extensions/HexColorExtension.dart';
import 'models/UserModel.dart';

//Icons
const String ASSET_directions_icon = 'assets/images/directions_icon.png';
const String ASSET_site_login_icon = 'assets/images/site_login_icon.png';
const String ASSET_website_icon = 'assets/images/website_icon.png';
const String ASSET_pp_text_logo = 'assets/images/pp_text_logo.png';
const String ASSET_play_button = 'assets/images/play_button.png';
const String ASSET_about_page_logos = 'assets/images/about_page_logos.png';
const String ASSET_IMAGE_LOGO = 'assets/images/splash_logo.png';
const String ASSET_IMAGE_P2K_TEXT = 'assets/images/preschool_text.png';
const String ASSET_IMAGE_OR = 'assets/images/or_logo.png';
const String ASSET_p2k20_app_opening_photo =
    'assets/images/p2k20_app_opening_photo.png';
const String ASSET_p2k20_app_white_logo =
    'assets/images/p2k20_app_white_logo.png';
const String ASSET_p2k20_app_blue_background =
    'assets/images/p2k20_app_blue_background.png';
const String ASSET_p2k20_app_header_bar =
    'assets/images/p2k20_app_header_bar.png';
const String ASSET_icon_my_passport = 'assets/images/icon_my_passport.png';
const String ASSET_icon_reading_log = 'assets/images/icon_reading_log.png';
const String ASSET_icon_visit_log = 'assets/images/icon_visit_log.png';
const String ASSET_icon_book_of_the_month =
    'assets/images/icon_book_of_the_month.png';
const String ASSET_icon_awesome_reading_tips =
    'assets/images/icon_awesome_reading_tips.png';
const String ASSET_icon_edit_profile = 'assets/images/icon_edit_profile.png';
const String ASSET_icon_about = 'assets/images/icon_about.png';
const String ASSET_icon_settings = 'assets/images/icon_settings.png';
const String ASSET_p2k20_app_dotted_line =
    'assets/images/p2k20_app_dotted_line.png';
const String ASSET_success_message_background =
    'assets/images/success_message_background.png';

const String STAMP_BOONSHOFT =
    'https://firebasestorage.googleapis.com/v0/b/passport-to-kindergarten.appspot.com/o/Images%2FStamps%2Fboonshoft.png?alt=media&token=fd342060-9b10-4b81-88eb-7340cb139ffb';
const String STAMP_DAYTON_ART_INSTITUE =
    'https://firebasestorage.googleapis.com/v0/b/passport-to-kindergarten.appspot.com/o/Images%2FStamps%2Fdayton_art_institute.png?alt=media&token=1d1818bc-d02f-4eb2-ad7a-ceb85de1e589';
const String STAMP_DAYTON_METRO_LIBRARY =
    'https://firebasestorage.googleapis.com/v0/b/passport-to-kindergarten.appspot.com/o/Images%2FStamps%2Fdayton_metro_library.png?alt=media&token=36c8ad0a-b3c0-4824-b385-d917e8ff5007';
const String STAMP_FIVE_RIVERS_METROPARKS =
    'https://firebasestorage.googleapis.com/v0/b/passport-to-kindergarten.appspot.com/o/Images%2FStamps%2Ffive_rivers_metro_park.png?alt=media&token=ad4d96b7-09a6-4c43-b456-817d0ecde138';
const String STAMP_15_BOOKS_READ =
    'https://firebasestorage.googleapis.com/v0/b/passport-to-kindergarten.appspot.com/o/Images%2FStamps%2F15_books_read.png?alt=media&token=9f225e2c-f15f-4505-ab03-fec3ba26c2dc';

const String LOGO_BOONSHOFT =
    'https://firebasestorage.googleapis.com/v0/b/passport-to-kindergarten.appspot.com/o/Images%2FVisits%2Fboonshoft_logo.png?alt=media&token=f0d0ed23-c108-4fc0-a3dd-191939f4042d';
const String LOGO_DAYTON_ART_INSTITUTE =
    'https://firebasestorage.googleapis.com/v0/b/passport-to-kindergarten.appspot.com/o/Images%2FVisits%2Fdayton_art_institute_logo.png?alt=media&token=34625dc5-f3fa-4d9e-927b-1fb27bb3a2da';
const String LOGO_DAYTON_METRO_LIBRARY =
    'https://firebasestorage.googleapis.com/v0/b/passport-to-kindergarten.appspot.com/o/Images%2FVisits%2Fdayton_metro_library_logo.png?alt=media&token=980f60fb-e5f5-4c4f-8ee1-08accb811a36';
const String LOGO_FIVE_RIVERS_METROPARKS =
    'https://firebasestorage.googleapis.com/v0/b/passport-to-kindergarten.appspot.com/o/Images%2FVisits%2Ffive_rivers_metroparks_logo.png?alt=media&token=2ba8c9b1-9df2-4547-acfb-88c88965a1c9';

//OTHER
const String DUMMY_PROFILE_PHOTO_URL =
    'https://firebasestorage.googleapis.com/v0/b/hidden-gems-e481d.appspot.com/o/Images%2FUsers%2FDummy%2FProfile.jpg?alt=media&token=99cd4cbd-7df9-4005-adef-b27b3996a6cc';

//Phone & Email
const String COMPANY_EMAIL = 'passport@preschoolpromise.org';

const String PRIVACY_POLICY_URL =
    'https://drive.google.com/file/d/1jnEsgbh_7sSFHEvdYdEF54QSbPDTUysS/view?usp=sharing';

//COLORS
final HexColorExtension colorCream = HexColorExtension('#fff8ec');
final HexColorExtension colorDarkCream = HexColorExtension('#ffe3b9');
final HexColorExtension colorOrange = HexColorExtension('#f4692f');
final HexColorExtension colorNavy = HexColorExtension('#09487e');
final HexColorExtension colorYellow = HexColorExtension('#ffbc5a');

//KEYS
const String ALGOLIA_APP_ID = 'UO39GB988T';
const String ALGOLIA_SEARCH_API_KEY = 'a2688a24cb08d1b78aae5dcde6f1d54f';
const String SECRET_SUPER_ADMIN_SIGNUP_KEY = 'XXX';

//GLOBAL VARIABLES
String version;
String buildNumber;
double screenWidth;
double screenHeight;

//ENUMS
enum PROFILE_TYPE {
  TEACHER,
  PARENT,
  SUPER_ADMIN,
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
  EDIT_PROFILE,
  AWESOME_READING_TIPS
}

UserModel idkTeacherModel = UserModel(
  created: DateTime.now(),
  imgUrl: DUMMY_PROFILE_PHOTO_URL,
  lastName: 'I do not know the teacher',
  firstName: '',
  email: 'johndoe@gmail.com',
  teacherID: null,
  dob: null,
  school: 'I do not know the school',
  fcmToken: null,
  profileType: PROFILE_TYPE.TEACHER.name,
  uid: 'Bmu4w172HWamn97TRhZr',
  primaryParentFirstName: null,
  primaryParentLastName: null,
  secondaryParentFirstName: null,
  secondaryParentLastName: null,
  bookLogCount: null,
  stampCount: null,
  visitLogCount: null,
);

extension PROFILE_TYPE_EXTENSION on PROFILE_TYPE {
  String get name {
    switch (this) {
      case PROFILE_TYPE.TEACHER:
        return 'TEACHER';
      case PROFILE_TYPE.PARENT:
        return 'PARENT';
      case PROFILE_TYPE.SUPER_ADMIN:
        return 'SUPER_ADMIN';
      default:
        return null;
    }
  }
}
