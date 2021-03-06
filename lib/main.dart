import 'package:auth_repository/auth_repository.dart';
import 'package:cat_app/bloc/cat_likes/bloc.dart';
import 'package:cat_app/bloc/cat_likes/likes_repository.dart';
import 'package:cat_app/screens/home/blocs/tab/tab_bloc.dart';
import 'package:cat_app/screens/home/view/home_page.dart';
import 'package:cat_app/screens/login/view/login_page.dart';
import 'package:cat_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/bloc.dart';
import 'bloc/cat_facts/bloc.dart';
import 'bloc/cat_images/bloc.dart';
import 'bloc/cat_likes/bloc.dart';
import 'common/check_internet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 
  runApp(MyApp());
 
}


    
  



class MyApp extends StatelessWidget {

  final authenticationRepository = AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authenticationRepository.user.first,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(debugShowCheckedModeBanner: false,
            home: Text('Error connecting to firebase'),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<CatsBloc>(
                    create: (context) => CatsBloc()..add(InitialCats())),
                BlocProvider(
                  create: (_) => AppBloc(
                    authenticationRepository: authenticationRepository,
                  ),
                ),
                BlocProvider<TabBloc>(create: (context) => TabBloc()),
                BlocProvider<LikeBloc>(
                    create: (context) =>
                        LikeBloc(likeRepository: LikesRepository())),
                BlocProvider<CatFactsBloc>(
                    create: (context) => CatFactsBloc()..add(FactsLoaded())),
              ],
              child: BlocBuilder<AppBloc, AppState>(
                  buildWhen: (previous, current) {
                return true;
              }, builder: (context, state) {
                if (authenticationRepository.currentUser.isNotEmpty) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: theme,
                    title: 'Cats App',
                    home: Home(),
                  );
                } else {
                  return FutureBuilder(
                      future: check(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          bool internet = snapshot.data as bool;
                          if (internet) {
                            return RepositoryProvider.value(
                              value: authenticationRepository,
                              child: BlocProvider(
                                create: (_) => AppBloc(
                                  authenticationRepository:
                                      authenticationRepository,
                                ),
                                child: const MaterialApp(
                                  debugShowCheckedModeBanner: false,
                                  title: 'Cats App',
                                  home: LoginPage(),
                                ),
                              ),
                            );
                          } else {
                            return MaterialApp(
                              debugShowCheckedModeBanner: false,
                              home: Scaffold(
                                body: Center(
                                  child: Text('No internet connection!'),
                                ),
                              ),
                            );
                          }
                        } else {
                          return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            home: Scaffold(
                              body: Center(
                                child: Text('No internet connection!'),
                              ),
                            ),
                          );
                        }
                      });
                }
              }),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
