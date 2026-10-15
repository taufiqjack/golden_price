import 'package:alice/alice.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_cubit.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_cubit.dart';
import 'package:golden_price/core/bloc/cubits/saham_top7_cubit/saham_top7_cubit.dart';
import 'package:golden_price/core/constants/color_customs.dart';
import 'package:golden_price/core/constants/cons.dart';
import 'package:golden_price/core/depedencies/injection.dart';
import 'package:golden_price/core/helpers/theme_mode_notifier.dart';
import 'package:golden_price/core/routes/app_route.dart';
import 'package:golden_price/firebase_options.dart';
import 'package:golden_price/pages/dashboard/view/dashboard_view.dart';
import 'package:hijriyah_indonesia/hijriyah_indonesia.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Hijriyah.setLocal('id');
  await dotenv.load(fileName: ENV_PATH);
  Injection.init();
  log = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<GoldPriceCubit>(),
        ),
        BlocProvider(
          create: (context) => locator<CurrencyCubit>(),
        ),
        BlocProvider(
          create: (context) => locator<SahamTop7Cubit>(),
        ),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeModeNotifier.instance,
        builder: (context, themeMode, _) => MaterialApp(
          builder: (context, child) {
            FToastBuilder();
            final palette = CorePalette.of(context);
            final iconBrightness =
                palette.isDark ? Brightness.light : Brightness.dark;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: iconBrightness,
                statusBarBrightness:
                    palette.isDark ? Brightness.dark : Brightness.light,
                systemNavigationBarColor: palette.bg,
                systemNavigationBarIconBrightness: iconBrightness,
              ),
              child: ResponsiveBreakpoints.builder(child: child!, breakpoints: [
                const Breakpoint(start: 0, end: 420, name: MOBILE),
                const Breakpoint(start: 421, end: 820, name: TABLET),
                const Breakpoint(start: 821, end: 1000, name: DESKTOP),
              ]),
            );
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: corePrimaryColor),
            useMaterial3: true,
            extensions: const [CorePalette.light],
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: corePrimaryColor,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            extensions: const [CorePalette.dark],
          ),
          themeMode: themeMode,
          home: DashboardView(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          navigatorKey: alice.getNavigatorKey(),
        ),
      ),
    );
  }
}
