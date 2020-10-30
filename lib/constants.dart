import 'package:p/extensions/HexColorExtension.dart';
import 'package:p/models/BookOfTheMonthModel.dart';
import 'models/UserModel.dart';

//Books of the Month
const String ASSET_LOLA_GOES_TO_SCHOOL =
    'assets/images/bom/lola_goes_to_school.jpg';
const String ASSET_THE_LITTLE_OLD_LADY_WHO_WAS_NOT_AFRAID_OF_ANYTHING =
    'assets/images/bom/the_little_old_lady_who_was_not_afraid_of_anything.jpg';
const String ASSET_BEAR_SAYS_THANKS = 'assets/images/bom/bear_says_thanks.jpg';
const String ASSET_THE_GINGERBREAD_MAN =
    'assets/images/bom/the_gingerbread_man.jpg';
const String ASSET_THE_MITTEN = 'assets/images/bom/the_mitten.jpg';
const String ASSET_DONT_LET_THE_PIGEON_DRIVE_THE_BUS =
    'assets/images/bom/dont_let_the_pigeon_drive_the_bus.jpg';
const String ASSET_LOLA_PLANTS_A_GARDEN =
    'assets/images/bom/lola_plants_a_garden.jpg';
const String ASSET_PETE_THE_CAT_AND_HIS_FOUR_GROOVY_BUTTONS =
    'assets/images/bom/pete_the_cat_and_his_four_groovy_buttons.jpg';
const String ASSET_NOT_A_BOX = 'assets/images/bom/not_a_box.jpg';
const String ASSET_THE_THREE_BILLY_GOATS_GRUFF =
    'assets/images/bom/the_three_billy_goats_gruff.jpg';
const String ASSET_FREIGHT_TRAIN = 'assets/images/bom/freight_train.jpeg';
const String ASSET_I_GOT_THE_RHYTHM = 'assets/images/bom/i_got_the_rhythm.jpg';

//Icons
const String ASSET_boonshoft_logo = 'assets/images/boonshoft_logo.png';
const String ASSET_directions_icon = 'assets/images/directions_icon.png';
const String ASSET_site_login_icon = 'assets/images/site_login_icon.png';
const String ASSET_website_icon = 'assets/images/website_icon.png';
const String ASSET_pp_text_logo = 'assets/images/pp_text_logo.png';
const String ASSET_play_button = 'assets/images/play_button.png';
const String ASSET_about_page_logos = 'assets/images/about_page_logos.png';
const String ASSET_IMAGE_LOGO = 'assets/images/splash_logo.png';
const String ASSET_IMAGE_P2K_LOGO = 'assets/images/icon_p2k.png';
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
const String ASSET_p2k20_app_stamp_15_books_read =
    'assets/images/stamp_15_books_read.png';
const String ASSET_stamp_boonshoft = 'assets/images/stamp_boonshoft.png';
const String ASSET_stamp_dayton_art_institute =
    'assets/images/stamp_dayton_art_institute.png';
const String ASSET_stamp_dayton_metro_library =
    'assets/images/stamp_dayton_metro_library.png';
const String ASSET_stamp_five_rivers_metro_park =
    'assets/images/stamp_five_rivers_metro_park.png';

//Vist Log
const String ASSET_dayton_metro_library_logo =
    'assets/images/dayton_metro_library_logo.png';
const String ASSET_five_rivers_metroparks_logo =
    'assets/images/five_rivers_metroparks_logo.png';
const String ASSET_dayton_art_institute_logo =
    'assets/images/dayton_art_institute_logo.png';

//OTHER
const String DUMMY_PROFILE_PHOTO_URL =
    'https://firebasestorage.googleapis.com/v0/b/hidden-gems-e481d.appspot.com/o/Images%2FUsers%2FDummy%2FProfile.jpg?alt=media&token=99cd4cbd-7df9-4005-adef-b27b3996a6cc';

//COLORS
final HexColorExtension COLOR_CREAM = HexColorExtension('#fff8ec');
final HexColorExtension COLOR_DARK_CREAM = HexColorExtension('#ffe3b9');
final HexColorExtension COLOR_ORANGE = HexColorExtension('#f4692f');
final HexColorExtension COLOR_NAVY = HexColorExtension('#09487e');
final HexColorExtension COLOR_YELLOW = HexColorExtension('#ffb653');

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

UserModel IDK_TEACHER_MODEL = UserModel(
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
);

final List<BookOfTheMonthModel> BOOKS_OF_THE_MONTH = [
  BookOfTheMonthModel(
    title: 'Lola Goes To School',
    assetImagePath: ASSET_LOLA_GOES_TO_SCHOOL,
    author: 'Anna McQuinn',
    given: true,
  ),
  BookOfTheMonthModel(
    title: 'The Little Old Lady Who Was Not Afraid of Anything',
    assetImagePath: ASSET_THE_LITTLE_OLD_LADY_WHO_WAS_NOT_AFRAID_OF_ANYTHING,
    author: 'Linda Williams',
    given: true,
  ),
  BookOfTheMonthModel(
    title: 'Bear Says Thanks',
    assetImagePath: ASSET_BEAR_SAYS_THANKS,
    author: 'Karma Wilson',
    given: true,
  ),
  BookOfTheMonthModel(
    title: 'The Gingerbread Man',
    assetImagePath: ASSET_THE_GINGERBREAD_MAN,
    author: 'Karen Schmidt',
    given: false,
  ),
  BookOfTheMonthModel(
    title: 'The Mitten',
    assetImagePath: ASSET_THE_MITTEN,
    author: 'Jan Brett',
    given: false,
  ),
  BookOfTheMonthModel(
    title: 'Don\'t Let the Pigeon Drive the Bus',
    assetImagePath: ASSET_DONT_LET_THE_PIGEON_DRIVE_THE_BUS,
    author: 'Mo Williams',
    given: false,
  ),
  BookOfTheMonthModel(
    title: 'Lola Plants a Garden',
    assetImagePath: ASSET_LOLA_PLANTS_A_GARDEN,
    author: 'Anna McQuinn',
    given: false,
  ),
  BookOfTheMonthModel(
    title: 'Pete the Cat and His Four Groovy Buttons',
    assetImagePath: ASSET_PETE_THE_CAT_AND_HIS_FOUR_GROOVY_BUTTONS,
    author: 'Eric Litwin & James Dean',
    given: false,
  ),
  BookOfTheMonthModel(
    title: 'Not a Box',
    assetImagePath: ASSET_NOT_A_BOX,
    author: 'Antoinette Portis',
    given: false,
  ),
  BookOfTheMonthModel(
    title: 'The Three Billy Goats Gruff',
    assetImagePath: ASSET_THE_THREE_BILLY_GOATS_GRUFF,
    author: 'Ellen Appleby',
    given: false,
  ),
  BookOfTheMonthModel(
    title: 'Freight Train',
    assetImagePath: ASSET_FREIGHT_TRAIN,
    author: 'Donald Crews',
    given: false,
  ),
  BookOfTheMonthModel(
    title: 'I Got the Rhythm',
    assetImagePath: ASSET_I_GOT_THE_RHYTHM,
    author: 'Connie Schofield-Morrison',
    given: false,
  ),
];

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
