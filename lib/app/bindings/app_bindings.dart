import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/movie_controller.dart';
import '../services/movie_provider.dart';

/// Initial bindings loaded at app start.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put(MovieProvider(), permanent: true);

    // Controllers
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => MovieController(), fenix: true);
  }
}
