import 'package:chatter_up/services/auth/auth_service.dart';
import 'package:chatter_up/components/my_botton.dart';
import 'package:chatter_up/components/my_text.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
    //email and pw controllers
  final TextEditingController _emailController = TextEditingController();  
  final TextEditingController _pwController = TextEditingController(); 
  final TextEditingController _confirmPwController = TextEditingController(); 

  //tap to go to register page
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  //register method
  void register(BuildContext context){
    //get auth service
    final _auth = AuthService();

    //passwords match -> create user

    if(_pwController.text == _confirmPwController.text){
      try{
        _auth.signUpWithEmailPassword(
      _emailController.text, 
      _pwController.text 
      );
      }catch(e){
        showDialog(
        context: context, 
        builder: (context) => AlertDialog(
        title: Text(e.toString()),
        )
      );
      }
    }
    //password dont match -> show an error
    else{
      showDialog(
        context: context, 
        builder: (context) => const AlertDialog(
        title: Text("Password don't match"),
        )
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body:  Center (
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.message, 
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              //welcome back msg
              Text(
              "Let's create an Account for ya!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16
                ),
              ),

              const SizedBox(height: 25),
              
              //email textfield
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: _emailController,
              ),

              const SizedBox(height: 10,),
              //pw textfield
              MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: _pwController,
              ),

              const SizedBox(height: 10),
              //confirm password
              MyTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: _confirmPwController,
              ),

              const SizedBox(height: 25,),
              //loging button
              MyBotton(
                text: "R E G I S T E R",
                onTap: () => register(context),
              ),
              const SizedBox(height: 25,),
              //register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an Account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      " Login now", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                    ),
                  )
                ],
              ),
              
            ],
        ),
      ),
    );
  }
}