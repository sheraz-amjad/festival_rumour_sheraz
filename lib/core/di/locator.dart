import 'package:get_it/get_it.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_apple.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';

final GetIt locator = GetIt.instance;

/// Initialize dependency injection
Future<void> setupLocator() async {
  // Services
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  
  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(locator<AuthService>()));
  
  // Use cases
  locator.registerFactory<SignInWithGoogle>(() => SignInWithGoogle(locator<AuthRepository>()));
  locator.registerFactory<SignInWithApple>(() => SignInWithApple(locator<AuthRepository>()));
}


