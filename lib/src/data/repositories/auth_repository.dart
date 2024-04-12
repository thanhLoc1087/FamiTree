// class AuthRepository {
//   static AuthRepository? _instance;

//   static AuthRepository get instance {
//     assert(_instance != null, "Auth instance has not been initialized!");
//     return _instance!;
//   }

//   AuthRepository._({
//     required RemoteAuthService remote,
//     required LocalAuthService local,
//   })  : _localAuthService = local,
//         _remoteAuthService = remote,
//         _notificationService = NotificationService(),
//         _forgotHandler = null,
//         _model = null;

//   static Future<void> initialize<M extends ModelBase>({
//     required RemoteAuthService remoteAuthService,
//     required LocalAuthService localAuthService,
//   }) async {
//     _instance ??=
//         AuthRepository<M>._(remote: remoteAuthService, local: localAuthService);
//     await _instance!._initialize();
//   }

//   final LocalAuthService _localAuthService;
//   final RemoteAuthService _remoteAuthService;
//   final NotificationService _notificationService;

//   T? _model;

//   bool get authenticated => _model != null;

//   T? get model => _model;

//   ForgotHandler? _forgotHandler;

//   bool get isAdmin => T == ShopAdmin;

//   ShopAdmin get shopAdmin => _model as ShopAdmin;

//   UserModel get user => _model as UserModel;

//   Future<void> _initialize() async {
//     if (!Hive.isAdapterRegistered(3)) {
//       Hive.registerAdapter(AnonymousBookingAdapter());
//     }

//     // fetch admin data from local auth service
//     if (T == ShopAdmin) {
//       _model = await _localAuthService.getAdmin() as T?;
//       //ignore: avoid_print
//       debugPrint("Run as Admin");
//       updateFcmToken();

//       if (_model is ShopAdmin) {
//         if ((_model as ShopAdmin).id != null) {
//           checkLastUpdatePass((_model as ShopAdmin).id!);
//           _listenShopAccountChange();
//         }
//       }
//     }
//     // fetch admin data from local auth service
//     else if (T == UserModel) {
//       _model = await _localAuthService.getUser() as T?;
//       //ignore: avoid_print
//       debugPrint("Run as User");
//       updateFcmToken();

//       /// Nếu user đã đăng nhập rồi thì k hiển thị dialog nữa
//       if (_model != null) {
//         DialogUtils.hasShowRecommendDialogUserSignup = true;
//       }
//     } else {
//       throw Exception("Invalid Model");
//     }
//   }

//   void checkLastUpdatePass(String uid) async {
//     Logger().w("check authentication");
//     final savedLastTimeUpdatePass = await LocalStorageUtils.getLastUpdatePass();
//     final remoteLastUpdatePass =
//         await _remoteAuthService.getLastUpdatePass(uid);

//     if (remoteLastUpdatePass != null) {
//       if (savedLastTimeUpdatePass == null) {
//         LocalStorageUtils.saveLastUpdatePass(remoteLastUpdatePass.toString());
//       } else {
//         if (savedLastTimeUpdatePass.compareTo(remoteLastUpdatePass) != 0) {
//           Toasty.show("Đã hết phiên đăng nhập! Vui lòng đăng nhập lại");
//           logout();
//         }
//       }
//     }
//   }

//   void Function(bool authenticated)? authStateChanged;

//   Future<void> updateFcmToken() async {
//     final token = await _notificationService.getFcmToken();
//     if (token != null) {
//       if (_model is ShopAdmin) {
//         final shopId = (_model as ShopAdmin).id!;
//         _remoteAuthService.updateTokenShop(shopId, token);
//         Logger().w("update fcm token shop: $token");
//       } else if (_model is UserModel) {
//         final userId = (_model as UserModel).id;
//         _remoteAuthService.updateTokenUser(userId, token);
//         Logger().w("update fcm token user: $token");
//       }
//     }
//   }

//   Future<void> login(String emailOrPhone, String password) async {
//     // get device token for fcm
//     final token = await _notificationService.getFcmToken();
//     // if (token == null) throw Exception(-1);

//     // fetch admin data from local auth service
//     if (T == ShopAdmin) {
//       final shopAccount =
//           await _remoteAuthService.loginAsAdmin(emailOrPhone, password, token);

//       _model = shopAccount as T?;

//       /// Save username | phone
//       LocalStorageUtils.saveShopPhone(emailOrPhone);

//       _listenShopAccountChange();

//       Logger().w(
//           "Login shop account: ${(_model as ShopAdmin?)?.id} - ${(_model as ShopAdmin?)?.name}");
//     }
//     // fetch admin data from local auth service
//     else if (T == UserModel) {
//       _model =
//           await _remoteAuthService.login(emailOrPhone, password, token) as T?;
//       // final topics =
//       //     await _remoteAuthService.getTopics((_model as UserModel).id);
//       // _notificationService.subscribe(topics);

//       Logger().w(
//           "Login user account: ${(_model as UserModel?)?.id} - ${(_model as UserModel?)?.name}");
//     }

//     // model still null -> error
//     if (_model != null) {
//       if (T == ShopAdmin) {
//         await _localAuthService.putAdmin(_model as ShopAdmin);
//         if (authStateChanged != null) {
//           authStateChanged!(true);
//         }

//         ShopGlobal().listenAll();
//       } else if (T == UserModel) {
//         await _localAuthService.putUser(_model as UserModel);
//         if (authStateChanged != null) {
//           authStateChanged!(true);
//         }
//       }
//       Logger().w("FCM Token: $token");
//     } else {
//       throw AuthException(-1);
//     }
//   }

//   Future<void> logout() async {
//     // await _notificationService.refreshToken();
//     if (T == ShopAdmin) {
//       _cancelListenShopAccountChange();

//       final shopId = shopAdmin.id;
//       _model = null;

//       await _localAuthService.logoutAsAdmin();
//       if (shopId != null) {
//         _remoteAuthService.logoutShop(shopId);
//       }
//       LocalStorageUtils.clearShopSavedData();
//       // TODO(phu): Add when enable warning warehouse
//       // LocalStorageUtils.setWarningWarehouseRemind(null);
//       // LocalStorageUtils.setWarningWarehouseBranchIds([]);
//       ShopGlobal().disposeAll();
//     } else if (T == UserModel) {
//       _model = null;
//       await _localAuthService.logout();
//       LocalStorageUtils.clearUserSavedData();
//     }

//     if (authStateChanged != null) authStateChanged!(false);
//   }

//   Future<void> changePassword(
//     String oldPassword,
//     String newPassword,
//     String confirmPassword,
//   ) async {
//     if (newPassword.length < 6) throw AuthException(7);
//     if (confirmPassword != newPassword) throw AuthException(5);

//     if (T == ShopAdmin) {
//       await _remoteAuthService.changePasswordAsAdmin(
//         uid: (_model as ShopAdmin).id!,
//         oldPassword: oldPassword,
//         newPassword: newPassword,
//       );
//     } else if (T == UserModel) {
//       await _remoteAuthService.changePassword(
//         uid: (_model as UserModel).id,
//         oldPassword: oldPassword,
//         newPassword: newPassword,
//       );
//     }
//   }

//   Future<void> resetPassword(String password, String confirm) async {
//     if (password.length < 6) throw AuthException(7);
//     if (confirm != password) throw AuthException(5);

//     if (_forgotHandler != null) {
//       if (T == ShopAdmin) {
//         await _remoteAuthService.changePasswordAsAdmin(
//           uid: _forgotHandler!.id,
//           oldPassword: "",
//           newPassword: password,
//           forgot: true,
//         );
//       } else {
//         await _remoteAuthService.changePassword(
//           uid: _forgotHandler!.id,
//           oldPassword: "",
//           newPassword: password,
//           forgot: true,
//         );
//       }
//     }
//   }

//   Future<void> changeUserInformation({
//     String? name,
//     String? phone,
//     int? gender,
//     DateTime? birthday,
//     XFile? cover,
//     XFile? avatar,
//   }) async {
//     if (_model is UserModel) {
//       final res = await _remoteAuthService.userChangeInfo(
//         uid: (_model as UserModel).id,
//         name: name,
//         phone: phone,
//         gender: gender,
//         birthday: birthday,
//         cover: cover,
//         avatar: avatar,
//       );

//       _model = (_model as UserModel).copyWith(
//         name: name,
//         phone: phone,
//         gender: gender != null && gender != -1
//             ? gender
//             : (_model as UserModel).gender,
//         birthday: birthday,
//         avatar: res[0],
//         cover: res[1],
//       ) as T;

//       await _localAuthService.updateUser(_model as UserModel);
//     }
//   }

//   Future<void> changeShopSelectedBranch(String branchId) async {
//     if (_model is ShopAdmin) {
//       _model = (_model as ShopAdmin).copyWith(selectedBranch: branchId) as T;
//       _localAuthService.putAdmin(_model as ShopAdmin);
//     }
//   }

//   Future<void> sendOTP(String email) async {
//     final res = await _remoteAuthService.sendOTP(email, T == ShopAdmin);
//     _forgotHandler = ForgotHandler(
//       res[0],
//       res[1],
//       email,
//     );
//   }

//   Future<void> resendOTP() async {
//     if (_forgotHandler != null) {
//       final res = await _remoteAuthService.sendOTP(
//         _forgotHandler!.email,
//         T == ShopAdmin,
//       );

//       _forgotHandler!.updateOTP(res[0]);
//     }
//   }

//   bool otpCompare(String otp) =>
//       _forgotHandler != null ? _forgotHandler!.compare(otp) : false;

//   Future<void> forgotPassword(String newPassword, String uid) async {
//     if (T == ShopAdmin) {
//       _remoteAuthService.changePasswordAsAdmin(
//           uid: uid, oldPassword: "", newPassword: newPassword, forgot: true);
//     } else {
//       _remoteAuthService.changePassword(
//           uid: uid, oldPassword: "", newPassword: newPassword, forgot: true);
//     }
//   }

//   Future<void> register(String user, String name, String pass) async {
//     if (T != ShopAdmin) {
//       await _remoteAuthService.register(
//           name: name, password: pass, emailOrPhone: user);
//     }
//   }

//   Future<void> updateLanguage(String lang) async {
//     if (_model is UserModel) {
//       FirebaseFirestore.instance
//           .collection(AppCollections.userAccount)
//           .doc((_model as UserModel).id)
//           .update({"lang": lang});
//     }
//   }

//   /// Listen Shop Account Change
//   StreamSubscription? subscriptionShopAccount;

//   _cancelListenShopAccountChange() {
//     subscriptionShopAccount?.cancel();
//     subscriptionShopAccount = null;
//   }

//   _listenShopAccountChange() {
//     if (_model is! ShopAdmin) return;
//     final id = shopAdmin.id;

//     Logger().i("listen shop account change");

//     subscriptionShopAccount?.cancel();
//     subscriptionShopAccount = null;

//     subscriptionShopAccount = FirebaseFirestore.instance
//         .collection(AppCollections.shopAccount)
//         .doc(id)
//         .snapshots()
//         .listen((event) {
//       if (event.data() != null) {
//         Logger().i("listen shop account change 2");
//         final updated = ShopAdmin.fromMap(
//           id: event.id, 
//           event.data()!, 
//           bossModel: shopAdmin.bossModel
//         );
//         if (!shopAdmin.isSame(updated)) {
//           final account = shopAdmin.copyWith(
//             name: updated.name,
//             avatar: updated.avatar,
//             cover: updated.cover,
//             email: updated.email,
//             phone: updated.phone,
//             features: updated.features,
//             featuresNew: updated.featuresNew,
//             branches: updated.branches,
//             status: updated.status,
//           );

//           _model = account as T?;

//           /// Call to update UI
//           ShopGlobal().changedShopAccount();
//         }
//       }
//     });
//   }
// }
