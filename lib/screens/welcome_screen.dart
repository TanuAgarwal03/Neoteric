import 'package:flutter/material.dart';
import '../modules/widgets/base_button.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 35),
              child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/mainlogo.png',width: 126,height: 73,),
                    //Image.asset('assets/logo.png',width: 126,height: 73,),
                    Image.asset('assets/home_screen_welcome.png'),
                    const Text('Apno ke liye, Sapno ke liye',style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24
                    ),),
                    const SizedBox(height: 25,),
                    BaseButton(onPress: (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          const LoginScreen()), (Route<dynamic> route) => false);
                    },title: "Log in",fontSize: 20,),
                    const SizedBox(height: 15,),
                    const Text('This app is only for existing Neoteric customers',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF383838),
                        fontWeight: FontWeight.w700
                      ),),
                    const SizedBox(height: 15,),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
