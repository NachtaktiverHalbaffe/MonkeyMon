import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:monkey_mon/src/presentation/widgets/theme_data.dart';
import 'package:theme_manager/theme_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monkey_mon/src/presentation/screens/arena_screen.dart';
import 'package:monkey_mon/src/presentation/screens/monkeydex_screen.dart';
import 'package:monkey_mon/src/presentation/screens/pokedex_screen.dart';
import 'package:monkey_mon/src/presentation/screens/settings_screen.dart';
import 'package:monkey_mon/src/presentation/widgets/bottom_nav_bar.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeManager(
      defaultBrightnessPreference: BrightnessPreference.system,
      loadBrightnessOnStart: true,
      data: (Brightness brightness) {
        switch (brightness) {
          case Brightness.dark:
            return darkTheme;
          case Brightness.light:
            return lightTheme;
          default:
            return darkTheme;
        }
      },
      themedWidgetBuilder: (BuildContext context, ThemeData theme) =>
          MaterialApp(
        // Providing a restorationScopeId allows the Navigator built by the
        // MaterialApp to restore the navigation stack when a user leaves and
        // returns to the app after it has been killed while running in the
        // background.
        restorationScopeId: 'app',

        // Provide the generated AppLocalizations to the MaterialApp. This
        // allows descendant Widgets to display the correct translations
        // depending on the user's locale.
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],

        // Use AppLocalizations to configure the correct application title
        // depending on the user's locale.
        //
        // The appTitle is defined in .arb files found in the localization
        // directory.
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appTitle,

        // Define a light and dark color theme. Then, read the user's
        // preferred ThemeMode (light, dark, or system default) from the
        // SettingsController to display the correct theme.
        theme: theme,
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(initialPage: 0);

  /// widget list
  final List<Widget> bottomBarPages = [
    PokedexScreen(),
    const MonkeydexScreen(),
    const ArenaScreen(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        restorationId: 'app',
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottonNavBar(onTap: (index) {
        _pageController.jumpToPage(index);
      }),
    );
  }
}
