import 'package:stacked/stacked.dart';
import 'package:swift_chat/app/app.locator.dart';
import 'package:swift_chat/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:swift_chat/services/auth.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 1));

    if (_authService.user == null) {
      _navigationService.replaceWithAuthView();
    } else {
      _navigationService.replaceWithHomeView();
    }
  }
}
