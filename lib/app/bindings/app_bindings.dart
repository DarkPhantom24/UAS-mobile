import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/movie_controller.dart';
import '../controllers/main_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/loved_controller.dart';
import '../controllers/search_controller.dart';
import '../controllers/profile_controller.dart';
import '../services/movie_provider.dart';

/// Initial bindings loaded at app start.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put(MovieProvider(), permanent: true);

    // Core Controllers
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => MovieController(), fenix: true);
    Get.lazyPut(() => MainController(), fenix: true);

    // View Controllers
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => LovedController(), fenix: true);
    Get.lazyPut(() => SearchController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
  }
}
