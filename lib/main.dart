import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/flutter_support_language.dart';

StateProvider<Locale> _localeProvider =
    StateProvider((ref) => AppLocalizations.supportedLocales.first);
StateProvider<int> _countProvider = StateProvider((ref) => 0);
StateProvider<String> _langCodeProvider = StateProvider(
    (ref) => AppLocalizations.supportedLocales.first.languageCode);
Provider<bool> _showAppBarProvider = Provider((ref) => ref.watch(_localeProvider
    .select((value) => flutterSupportLanguage.contains(value.toString()))));

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: AppLocalizations.localizationsDelegates, // 追加
      supportedLocales: AppLocalizations.supportedLocales, // 追加
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      locale: ref.watch(_localeProvider),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  final countLocales = AppLocalizations.supportedLocales.length;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isAppBarShown = Localizations.of<MaterialLocalizations>(
            context, MaterialLocalizations) !=
        null;

    return Scaffold(
      appBar: ref.watch(_showAppBarProvider)
          ? AppBar(
              title: Text(AppLocalizations.of(context).title),
            )
          : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).message,
            ),
            Text(
              '${ref.watch(_countProvider)}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '${ref.watch(_langCodeProvider)}',
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(_countProvider.notifier).state++;

          Locale currentLocale = AppLocalizations
              .supportedLocales[ref.read(_countProvider) % countLocales];
          ref.read(_localeProvider.notifier).update((state) => currentLocale);
          ref.read(_langCodeProvider.notifier).update((state) =>
              '${currentLocale.languageCode}-${currentLocale.countryCode ?? ''}');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
