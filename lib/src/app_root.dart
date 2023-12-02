import 'package:chat_app/cubits/login/login_cubit.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/notifications_screen.dart';
import 'package:chat_app/screens/user_profile_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/chat/chat_cubit.dart';
import '../cubits/register/register_cubit.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => ChatCubit()),


      ],
      child: MaterialApp(
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          ProfileScreen.id: (context) => const ProfileScreen(),
          NotificationScreen.id: (context) => const NotificationScreen(),

        },
        initialRoute: LoginScreen.id,
       navigatorKey: navigatorKey,
       //  home: Test(),
       //  routes: {
       //   Test2.route: (context) => const Test2(),
       //  },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
