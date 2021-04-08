import 'package:get_it/get_it.dart';
import 'package:p/services/AnalyticsService.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/BookService.dart';
import 'package:p/services/DummyService.dart';
import 'package:p/services/FCMNotificationService.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ReportService.dart';
import 'package:p/services/StampService.dart';
import 'package:p/services/StorageService.dart';
import 'package:p/services/UserService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/services/LogService.dart';
import 'package:p/services/VisitService.dart';

GetIt locator = GetIt.I;

void setUpLocater() {
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => BookService());
  locator.registerLazySingleton(() => DummyService());
  locator.registerLazySingleton(() => FCMNotificationService());
  locator.registerLazySingleton(() => LogService());
  locator.registerLazySingleton(() => ModalService());
  locator.registerLazySingleton(() => ReportService());
  locator.registerLazySingleton(() => StampService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => ValidatorService());
  locator.registerLazySingleton(() => VisitService());
}
