import 'package:bloc/bloc.dart';
import 'package:doc_upload/application/authBloc/auth_event.dart';
import 'package:doc_upload/application/authBloc/auth_state.dart';
import 'package:doc_upload/infrastructure/repo_impl/auth_repository_impl.dart';
import 'package:doc_upload/utils/app_utils.dart';


class AuthProviderBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseApi _api = FirebaseApi();

 AuthProviderBloc() : super(InitialState()) {
    on<RegisterEvent>((event, emit) async {
      try {
        bool? success = await _api.registerUserWithEmailPassword(
          event.email,
          event.password,
        );
        if (success == true) {
          emit(AuthSuccessState("Register Success"));
        } else {
          emit(AuthErrorState("Registration Failed 😔 Try Agin"));
        }
      } catch (e) {
        emit(AuthErrorState("An error occurred during registration"));
      }
    });

    on<LoginEvent>((event, emit) async {
      try {
        bool? success = await _api.loginUsingEmailAndPassword(
          event.email,
          event.password,
        );
        if (success == true) {
          emit(AuthSuccessState("Logged in Successfully 🥳"));
        } else {
          emit(AuthErrorState("Incorrect Password"));
        }
      } catch (e) {
        emit(AuthErrorState("An error occurred during login"));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await _api.logOut();
        emit(AuthSuccessState("Logout Successfully"));
      } catch (e) {
        emit(AuthErrorState("An error occurred during logout"));
      }
    });

    on<ResetPasswordEvent>((event, emit)async{
    try{
      await _api.resetPassword(event.email);
      AppUtils.showSuccessMessage("Reset Email Send to your mail id");
    }catch (e) {
        emit(AuthErrorState("An error occurred during logout"));
      }
     
    });

   on<ChangePasswordEvent>((event, emit)async{
    try{
     await _api.changePassword(event.currentPassword,event.newPassword).then((value){
      if(value ==true){
      emit(AuthSuccessState("Password Changed Successfully 🥳"));
      }
      if(value == false){
        emit(AuthErrorState("Your Current Password is  InCorrect"));
      }
     });
    }catch(error){
      emit(AuthErrorState("An error occurred during password change 😔 Try Again"));
    }
   }); 
  }

  
}
