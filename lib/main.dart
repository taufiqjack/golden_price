import 'package:alice/alice.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:golden_price/core/bloc/cubits/cubit/gold_price_cubit.dart';
import 'package:golden_price/core/constants/cons.dart';
import 'package:golden_price/core/depedencies/injection.dart';
import 'package:golden_price/core/routes/app_route.dart';
import 'package:golden_price/pages/dashboard/view/dashboard_view.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ENV_PATH);
  Injection.init();
  log = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('id', 'ID'),
      ],
      path: 'assets/translations',
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var alice = locator<Alice>();
    alice.setNavigatorKey(Go.navigatorKey);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // navigation bar color
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light, // status bar color
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<GoldPriceCubit>(),
        ),
      ],
      child: MaterialApp(
        builder: (context, child) {
          FToastBuilder();
          return ResponsiveBreakpoints.builder(child: child!, breakpoints: [
            const Breakpoint(start: 0, end: 420, name: MOBILE),
            const Breakpoint(start: 421, end: 820, name: TABLET),
            const Breakpoint(start: 821, end: 1000, name: DESKTOP),
          ]);
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: DashboardView(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        navigatorKey: alice.getNavigatorKey(),
      ),
    );
  }
}
