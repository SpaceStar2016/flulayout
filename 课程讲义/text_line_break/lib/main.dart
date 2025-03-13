import 'package:flutter/material.dart';

void main() {
  runApp(
    Center(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
            color: Colors.grey,
            child: HotReloadWidget()),
      ),
    ),
  );
}

class HotReloadWidget extends StatelessWidget {
  const HotReloadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(58 / 3),
      ),
      child: Row(
        children: [
          FlutterLogo(
            size: (100),
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '获得面试机会',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 52 / 3,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  '我一个很长很长的文本我一个很长很长的文本我一个很长很长的文本我一个很长很长的文本我一个很长很长的文本',
                  style: TextStyle(
                    fontSize: 38 / 3,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999999),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      '10000',
                      style: TextStyle(
                          fontSize: 38 / 3,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      '次学习',
                      style: TextStyle(
                        fontSize: 38 / 3,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999999),
                      ),
                    ),
                    // Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


