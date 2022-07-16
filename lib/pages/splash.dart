import 'package:flutter/material.dart';

import 'landing_page.dart';

class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/brain.png',
                width: 300,
              ),
              SizedBox(
                height: 70,
              ),
              Text(
                'GAME OJO LALI',
                style: TextStyle(color: Colors.purple,
                fontSize: 32,)
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                'Ayok asah ingatan anda dengan memainkan Game ini',
                
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 210,
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LandingPage(),
                        ),
                        (route) => false);
                  },
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Text(
                    'Play Now',
                    style: TextStyle(color: Colors.white)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
