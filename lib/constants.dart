import 'package:p/extensions/HexColorExtension.dart';
import 'package:p/models/BookModel.dart';
import 'models/UserModel.dart';
import 'models/VisitModel.dart';

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

//Stamps

// final List<Image> stamps = [
//   Image.asset(
//     ASSET_p2k20_app_stamp_15_books_read,
//     height: 100,
//   ),
//   Image.asset(
//     ASSET_stamp_boonshoft,
//     height: 100,
//   ),
//   Image.asset(
//     ASSET_stamp_dayton_art_institute,
//     height: 100,
//   ),
//   Image.asset(
//     ASSET_stamp_dayton_metro_library,
//     height: 100,
//   ),
//   Image.asset(
//     ASSET_stamp_five_rivers_metro_park,
//     height: 100,
//   ),
// ];

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
final HexColorExtension COLOR_YELLOW = HexColorExtension('#ffbc5a');

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

final List<VisitModel> DEFAULT_VISITS = [
  VisitModel(
      id: null,
      created: DateTime.now(),
      modified: DateTime.now(),
      title: 'Boonshoft Museum of Discovery',
      logCount: 0,
      assetImagePath: ASSET_boonshoft_logo,
      website: 'https://www.boonshoftmuseum.org/',
      address: '2600 DeWeese Pkwy, Dayton, OH 45414, USA'),
  VisitModel(
    id: null,
    created: DateTime.now(),
    modified: DateTime.now(),
    title: 'Dayton Metro Library',
    logCount: 0,
    assetImagePath: ASSET_dayton_metro_library_logo,
    website: 'http://www.daytonmetrolibrary.org/',
    address: '215 E. Third St., Dayton, OH 45402, USA',
  ),
  VisitModel(
      id: null,
      created: DateTime.now(),
      modified: DateTime.now(),
      title: 'Five Rivers Metro Park',
      logCount: 0,
      assetImagePath: ASSET_five_rivers_metroparks_logo,
      website: 'https://www.metroparks.org/contact/',
      address: '409 E. Monument Ave., Dayton, OH 45402, USA'),
  VisitModel(
    id: null,
    created: DateTime.now(),
    modified: DateTime.now(),
    title: 'Dayton Art Institute',
    logCount: 0,
    assetImagePath: ASSET_dayton_art_institute_logo,
    website: 'https://www.daytonartinstitute.org/',
    address: '456 Belmonte Park N, Dayton, OH 45405, USA',
  )
];

final List<BookModel> DEFAULT_BOOKS = [
  BookModel(
    title: 'Lola Goes To School',
    assetImagePath: ASSET_LOLA_GOES_TO_SCHOOL,
    author: 'Anna McQuinn',
    given: true,
    summary:
        'When you share books with your child that reflect their experiences, their understanding of the story improves and their ability to learn new words increases. Stop and talk about their experiences as you read aloud. It\s also a good chance to learn what they are thinking and feeling.',
    conversationStarters: [
      'Why is starting school a big important day?',
      'Sometimes people are excited about going to school. Why do you think they might feel that way?',
      'Some children are afraid of going to school for the first time. Why do you think that may be?',
      'Share a time when you both felt excited or fearful about doing something new.',
      'What can you do when you feel nervous or upset to help yourself feel better.',
      'How does a person look when they feel worried or afraid?'
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
  ),
  BookModel(
    title: 'The Little Old Lady Who Was Not Afraid of Anything',
    assetImagePath: ASSET_THE_LITTLE_OLD_LADY_WHO_WAS_NOT_AFRAID_OF_ANYTHING,
    author: 'Linda Williams',
    given: true,
    summary:
        'There\'s a lot of repetition in this simple story. This repetition offers a good opportunity for children to memorize it and retell the sory themselves. Start this process off by pausing at the end of sentences for your child to finish the sentence. As you keep rereading, and they learn more, pause sooner and sooner until they are telling you the story!',
    conversationStarters: [
      'Did you ever walk in the woods and gather things you found? Tell about it. What did you find?'
          'Why do you think people stay on the trail when they walk in the woods?'
          'Should you eat something you find in the woods? Why or why not?',
      'Is there something that might scare you in the woods? Tell about it.'
          'Some things in books are real and true, but some things are make-believe. Go through this book and talk about what is real and what is make-believe.'
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
  ),
  BookModel(
    title: 'Bear Says Thanks',
    assetImagePath: ASSET_BEAR_SAYS_THANKS,
    author: 'Karma Wilson',
    given: true,
    summary:
        'There are more rare words in books than everday conversation. This is one reason why sharing books is so valuable for expanding your child\'s vocabulary. Rereading a book that they enjoy makes it more likely that they will learn unfamiliar words. Ask your child to pronounce any new words to help them learn to use the words in the future.',
    conversationStarters: [
      'Friends and family like to get together and share food. Tell about a time when you did this. What did you like about it?',
      'Sometimes families got together to share a meal on holidays and they eat special food. What food is special in your family? Is there a special food for birthdays? Is there a food that you only eat on holidays?',
      'If you were going to plan all the food to have for a feast, what foods would you like?',
      'People feel  thankful when they think about the things in their lives that make them happy. What are you some of the things in your life that make you feel happy?'
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
  ),
  BookModel(
    title: 'The Gingerbread Man',
    assetImagePath: ASSET_THE_GINGERBREAD_MAN,
    author: 'Karen Schmidt',
    given: false,
    summary:
        'When sharing picture books, parents can engage their children in critical thinking when they ask questions that start with "What if...?"',
    conversationStarters: [
      'What if you were cooking something that could run away? What might it be? How would it move?',
      'What if you were trying to catch the Gingerbread Man, how might you trap it? Can you think of some tools that you might use?',
      'What if the farmers had a tractor? What do you think might happen?',
      'What if the Gingerbread Man decided to hide somewhere? Where might he hide?',
      'What if the little boy caught the Gingerbread Man, what do you think he\'d do?'
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
  ),
  BookModel(
    title: 'The Mitten',
    assetImagePath: ASSET_THE_MITTEN,
    author: 'Jan Brett',
    given: false,
    summary:
        'As you and your child talk about books, your child gets good practice organizing their thinking into sentences that make sense to you and others. Your clarifying questions about what they are saying teaches themn what they need to say to be undersatood. When you get to the point that you think you understand, then repeat back the full thought to them in your language. Add a bit more to it, to model more advanced language.',
    conversationStarters: [
      'Who gave you your mittens/gloves to wear outside? If someone was going to make you a pair of mittens, which color would you choose?'
          'Why is the woman worried that the boy will lose his mitten? Is it hard for you to keep track of your mittens? Why do you think that is?'
          'Share stories of losing things. Do you feel like you are always losing a particular thing? Why might it be hard to keep track of.',
      'Does the boy in the story know why his mitten is all stretche out? Why not? What might the boy imagine happened to the stretched-out mitten?',
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
  ),
  BookModel(
    title: 'Don\'t Let the Pigeon Drive the Bus',
    assetImagePath: ASSET_DONT_LET_THE_PIGEON_DRIVE_THE_BUS,
    author: 'Mo Williams',
    given: false,
    summary:
        'Ask \'how\' and \'why\' questions to find out what your child is thinking. Sometimes what is obvious to us, isn\'t obvious to others. \'How\' and \'why\' questions generally require more advanced thinking than \'what\', \'where\', and \'who\' questions.',
    conversationStarters: [
      'Do you think bus the driver should let the pigeon drive the bus? Why or why not?',
      'Share something that you both wish you could do, but can\'t. Tell about it. Why can\'t you do it?',
      'How do you feel when someone tells you: "No, you can\t do that?" What can you do to feel beter?',
      'Is there something the pigeon can do that the bus driver can\'t do? What can you do that a one-year-old baby can\'t do?',
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
  ),
  BookModel(
    title: 'Lola Plants a Garden',
    assetImagePath: ASSET_LOLA_PLANTS_A_GARDEN,
    author: 'Anna McQuinn',
    given: false,
    summary:
        'It is important that children have conversation rather than just answer questions with one or two words. You can make this happen by asking questions that required their opinions or creative thinking. Respond to their ideas with your own opinions and creative ideas. Asking, "What is happening on this page?" is always a good strategy!',
    conversationStarters: [
      'When Lola decides to plant a garden, she goes to the library to get books about gardens. Why do you think she did that? Why did her mother make a list? Did you ever make a list with a grownup? Tell about it.',
      'If you go to the library, what kind of books do you like to get?',
      'Did you ever see a garden? Where was it and who did the work of tending it? What would you want to grow in a garden if you could?',
      'When Lola invites her friends to see her garden, she and her mother make cupcakes for them. If friends were coming to your house, what would you like to make for them? What clothes would you wear for a party like that? Who might you invite?'
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
  ),
  BookModel(
    title: 'Pete the Cat and His Four Groovy Buttons',
    assetImagePath: ASSET_PETE_THE_CAT_AND_HIS_FOUR_GROOVY_BUTTONS,
    author: 'Eric Litwin & James Dean',
    given: false,
    summary:
        'Most adults speak at a rate 160-180  words per minute and many can reach 190 words per minute. The problem is that most 3-5 years-olds process speech at 120-124 words per minute. They are still building neural connections in their brains. It turns out that Mr. Rogers spoke at the best rate for preschoolers: 124 words per minute. So, be like Mr. Rogers and slow it down. Preschoolers also need more of a wait time between when you take a turn in the conversation and when they can respond. Try silently counting to five while looking at them too.',
    conversationStarters: [
      'Usually cats don\'t wear clothing, why not? How do you think Pete got his yellow shirt?'
          'Why are there buttons on clothing? Can you think of other fasteners on clothing? Why don\'t we just glue our clothing on our bodies?',
      'Why do you think buttons sometimes pop off?',
      'Did you ever have a button come off your clothing? Tell about it.'
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
  ),
  BookModel(
    title: 'Not a Box',
    assetImagePath: ASSET_NOT_A_BOX,
    author: 'Antoinette Portis',
    given: false,
    summary:
        'In this book, the rabbit uses his imagination to turn a box into different things in this mind. For example, even though the box was once a car, it is now a mountain. This flexibility to think of one thing in different ways is an important thinking skill for school success.',
    conversationStarters: [
      'Where might the rabbit\'s box have come from?',
      'Did you ever play in a large box? Tell about it?'
          'If you had a box, what might you imagine it to be? What else? Take turns thinknig up examples or pantomiming it\'s use.'
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
  ),
  BookModel(
    title: 'The Three Billy Goats Gruff',
    assetImagePath: ASSET_THE_THREE_BILLY_GOATS_GRUFF,
    author: 'Ellen Appleby',
    given: false,
    summary:
        'Folk tales never seem to go out of fashion. Young children usually want to hear them read again and again. The theme of successfully overcoming or outsmarting something scary speaks to their experience in a significant way and is ultimately reassuring. The stories give form to their fears in the safety of your lap, and always end with "happily ever after".',
    conversationStarters: [
      'Why do the billy goats want to cross the bridge? How else might they get to the other side of the river?',
      'Why do you think the troll lives under the bridge?',
      'Why do the goats\' feet make the sound of "trip trap, trip trap"? Can you think of any other animals with hooves? What sound would your feet make on a wooden bridge?',
      'Some imaginary creatures are scary and some are not. A troll is an imaginary creature, can you think of other imaginary creatures?F',
      'What could you say to the troll to get him to let you cross the bridge?'
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
  ),
  BookModel(
    title: 'Freight Train',
    assetImagePath: ASSET_FREIGHT_TRAIN,
    author: 'Donald Crews',
    given: false,
    summary:
        'Most parents have heard the dictum "You are your child\'s first teacher." But honestly, you are also your child\'s first laundress, driver, cook and personal bather, among other things. So how do you find time to do it all? Here\'s one suggestion: While cleaning dishes or folding laudnry, ask your child to "read" a favorite book to you while you work. This practice retelling familiar stories is great for building language and literacy skills.',
    conversationStarters: [
      'Why do you think  coal/farm animals/people travel on trains? Where might they be going?',
      'How else do people travel from on place to another?'
          'Did you ever mail something? How do you think the card/letter/package got to where it was going?',
      'A plane travles faster than a train or a truck. Why do you think that is?'
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
  ),
  BookModel(
    title: 'I Got the Rhythm',
    assetImagePath: ASSET_I_GOT_THE_RHYTHM,
    author: 'Connie Schofield-Morrison',
    given: false,
    summary:
        'A fun way to learn new vocabulary is to act out the words. This books offers lots of opportunities to do just that. Encourage your child to say the rhythmic words while acting them out. Can he or she think of some other rhythmic motions to do and say? You could reinforce the idea of "rhythm" by taking a walk around your neighborhood to see if you can sopt any rhythmic moments.',
    conversationStarters: [
      'Sometimes people take a walk just for the fresh air and exercise. If you took a walk around your neighborhood what might you see?',
      'When the girl walks along the top of the wall, she holds her mother\'s hand. Why? When do you hold your gorwnups\'s hand?',
      'At one point int he story, there are lots of kids. Where do you think they are? Why do you think that?',
      'If you were that little girl\'s mother, what would you say to her?'
    ],
    modified: DateTime.now(),
    created: DateTime.now(),
    id: null,
    logCount: 0,
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
