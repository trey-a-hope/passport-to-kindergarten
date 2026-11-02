# Passport to Kindergarten

A Flutter app for Preschool Promise's Passport to Kindergarten program in Dayton, Ohio. Families log the books they read and the community places they visit, and each milestone earns a stamp in the child's digital passport. Teachers follow their class's progress and email reports, and a super admin oversees every account.

## Features

- **Three account types** (`PROFILE_TYPE` in `lib/constants.dart`): parent, teacher and super admin. Parents pick their child's teacher at sign-up, using an Algolia teacher search (`lib/blocs/searchTeachers/`).
- **My Passport**: the child's stamp collection. Stamps come from visits (Boonshoft Museum, Dayton Art Institute, Dayton Metro Library, Five Rivers MetroParks) and from reading milestones such as 15 books read (`lib/services/StampService.dart`).
- **Reading Log**: add books and log each time you read them (`lib/blocs/readingLog/`, `lib/services/BookService.dart`).
- **Visiting Log**: record trips to the partner sites, with directions and website links (`lib/blocs/visitingLog/`, `lib/services/VisitService.dart`).
- **Book of the Month** and **Awesome Reading Tips** pages.
- **My Class** (teachers): see each student's books, visits and stamps (`lib/blocs/myClass/`, `lib/blocs/student_details/`), and email an Excel report of a student's progress (`lib/services/ReportService.dart`).
- **Super Admin**: a view across all teachers and students (`lib/blocs/super_admin/`).
- Push notifications through Firebase Cloud Messaging, a confetti success screen, a guided tour of the menu on first launch, profile editing with photo cropping, and an in-app privacy policy PDF.

## How it works

The app is organized by feature under `lib/blocs/`, where each folder holds a page, its `flutter_bloc` Bloc and its events and states. Data lives in Firebase: Auth for accounts, Cloud Firestore for users, books, visits, logs and stamps, and Storage for profile photos and stamp images. Services in `lib/services/` wrap each Firebase area and are registered with `get_it` in `lib/ServiceLocator.dart`. Firebase Analytics records screen views through a navigator observer in `lib/main.dart`.

```
lib/
├── main.dart            # Firebase init, service locator, MaterialApp
├── constants.dart       # asset paths, stamp/logo URLs, enums, colors
├── blocs/               # one folder per screen (page + bloc + events + states)
├── models/              # User, Book, Log, Visit, Stamp, Entry
├── services/            # Auth, User, Book, Visit, Stamp, Report, Storage, FCM, Analytics
└── widgets/
```

## Tech stack

- Flutter, Dart SDK `>=2.7.0 <3.0.0` (pre-null-safety)
- `flutter_bloc` 7 and `get_it`
- Firebase: Auth, Cloud Firestore, Storage, Messaging, Analytics
- Algolia (teacher search), `excel` + `flutter_email_sender` (reports)
- `table_calendar`, `confetti`, `tutorial_coach_mark`, `advance_pdf_viewer`, `image_picker` / `image_cropper`

## Getting started

1. Install a Flutter SDK that still supports Dart 2.x (this project predates null safety, so current Flutter releases won't build it without migration).
2. The Firebase config files for the `passport-to-kindergarten` project are already committed (`android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`). Swap them for your own to point the app at a different Firebase project.
3. Install packages and run:

```sh
flutter pub get
flutter run
```

## Testing

`test/widget_test.dart` is the default Flutter counter test and doesn't match this app.
