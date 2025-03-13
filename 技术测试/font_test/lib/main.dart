import 'package:flutter/material.dart';

void main() {
  // runApp(Center(
  //   child: Container(
  //     // color: Colors.white,
  //     color: Colors.yellow,
  //   ),
  // ));

  runApp(MyABC());
}

class MyABC extends StatelessWidget {
  const MyABC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Caop',
      ),
      home: Scaffold(
        body: Container(
          // color: Colors.grey,
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  '生活-Opl',
                  style: TextStyle(
                    fontFamily: 'Opl',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 34,
                  ),
                ),
                Text(
                  '生活-系统默认',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 34,
                  ),
                ),
                Text(
                  '生活-PingFang',
                  style: TextStyle(
                    fontFamily: 'PingFang SC',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 34,
                  ),
                ),
                Text(
                  'abcdefghigklnmopqrstuvwxyz-系统默认',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  'abcdefghigklnmopqrstuvwxyz-系统默认',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'abcdefghigklnmopqrstuvwxyz-cau',
                  style: TextStyle(
                    fontFamily: 'Cau',
                    color: Colors.black,
                  ),
                ),
                Text(
                  'abcdefghigklnmopqrstuvwxyz-PingFang',
                  style: TextStyle(
                    fontFamily: 'PingFang SC',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 100,),
                Text(
                  '生活就像海洋-Caop',
                  style: TextStyle(
                    fontFamily: 'Caop',
                    color: Colors.black,
                    fontSize: 34,
                  ),
                ),
                Text(
                  '生活就像海洋-Caop',
                  style: TextStyle(
                    fontFamily: 'Caop',
                    color: Colors.black,
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '生活就像海洋-系统默认',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                  ),
                ),
                Text(
                  'abcdefghigklnmopqrstuvwxyz-Caop',
                  style: TextStyle(
                    fontFamily: 'Caop',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'abcdefghigklnmopqrstuvwxyz-Caop',
                  style: TextStyle(
                    fontFamily: 'Caop',
                    color: Colors.black,
                  ),
                ),
                Text(
                  'abcdefghigklnmopqrstuvwxyz-PingFang',
                  style: TextStyle(
                    fontFamily: 'PingFang SC',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
