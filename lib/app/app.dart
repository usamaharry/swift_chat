import 'package:swift_chat/services/auth.dart';
import 'package:swift_chat/services/firebase.dart';
import 'package:swift_chat/services/firestore.dart';
import 'package:swift_chat/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:swift_chat/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:swift_chat/ui/views/home/home_view.dart';
import 'package:swift_chat/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:swift_chat/ui/views/auth/auth_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: AuthView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: NavigationService),
    Singleton(classType: AuthService),
    Singleton(classType: FireStoreService),
    Singleton(classType: FirebaseService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
