import 'package:get_it/get_it.dart';
import 'package:p/services/AnalyticsService.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/FCMNotificationService.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/StorageService.dart';
import 'package:p/services/UserService.dart';
import 'package:p/services/ValidatorService.dart';

GetIt locator = GetIt.I;

void setUpLocater() {
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FCMNotificationService());
  locator.registerLazySingleton(() => ModalService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => ValidatorService());
}
