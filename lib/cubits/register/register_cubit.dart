import 'package:bloc/bloc.dart';
import 'package:chat_app/controller/user_controller.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../model/user.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerUser(
      UserModel newUser) async {
    emit(RegisterLoading());

    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: newUser.email, password: newUser.password);
      await createUser(newUser, FirebaseAuth.instance.currentUser!);

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(errMessage:'weak-password'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errMessage: 'email-already-in-use'));
      }
    }
    on Exception  catch (e){
      emit(RegisterFailure(errMessage: 'There was an error please try again $e'));
    }
  }
}
