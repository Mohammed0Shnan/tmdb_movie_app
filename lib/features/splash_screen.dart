
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getNextRoute().then((route) async{
        Navigator.pushNamedAndRemoveUntil(context, route ,(r)=> false);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }

  Future<String> _getNextRoute() async {
    await Future.delayed(Duration(milliseconds: 200));
    return '/home';
  }

}


