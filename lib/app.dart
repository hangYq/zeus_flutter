import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './pages/home_page/view.dart';
import './routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Zeus',
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: <Locale>[
        Locale('en', ''), // English, no country code
        Locale('es', ''), // Spanish, no country code
        Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hans',
          countryCode: 'CN',
        ), // 'zh_Hans_CN'
        Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
          countryCode: 'TW',
        ), // 'zh_Hant_TW'
        Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
          countryCode: 'HK',
        ), // 'zh_Hant_HK'
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // useMaterial3: true,
      ),
      home: const HomePage(),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            final String? name = settings.name;
            final PageBuilder pageContentBuilder = AppRoutes.routes[name]!;
            if (settings.arguments != null) {
              return pageContentBuilder(
                context,
                arguments: settings.arguments,
              );
            }
            return pageContentBuilder(context);
          },
        );
      },
    );
  }
}
