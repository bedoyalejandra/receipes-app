import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/components/primary_button.dart';
import 'package:receipes_app_02/constants/custom_colors.dart';
import 'package:receipes_app_02/presentation/screens/receipes/create_recipe_screen.dart';
import 'package:receipes_app_02/presentation/screens/splash_screen.dart';
import 'package:receipes_app_02/presentation/wrappers/auth_wrapper.dart';
import 'package:receipes_app_02/providers/theme_provider.dart';
import 'package:receipes_app_02/themes/app_themes.dart';
import 'package:receipes_app_02/core/depenpencies_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: DependenciesInjection.providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppThemes.ligthTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: CreateRecipeScreen(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color:
                        themeProvider.isDarkMode
                            ? Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.5)
                            : Theme.of(context).colorScheme.primary,
                  ),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  Icon(
                    Icons.dark_mode,
                    color:
                        themeProvider.isDarkMode
                            ? Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.5)
                            : Theme.of(context).colorScheme.primary,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return ListTile(
                    leading: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                    title: Text(
                      themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                    ),
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: Text('Add Recipe')),
            PrimaryButton(
              onPressed: () {},
              title: 'Primary Button',
              backgroundColor: CustomColors.secondaryColor,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
