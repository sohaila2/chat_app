import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/show_snack_bar.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    }on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(LoginFailure(errMessage: 'User not found.'));
      } else if (ex.code == 'incorrect-password') {
        emit(LoginFailure(errMessage: 'Wrong password.'));
      } else if (ex.code == 'invalid-email') {
        emit(LoginFailure(errMessage: 'Invalid email format'));
      } else {
        emit(LoginFailure(errMessage: 'Invalid email or password.'));
      }
    }on Exception catch(e){
      emit(LoginFailure(errMessage: 'something went wrong $e'));
    }
  }

}