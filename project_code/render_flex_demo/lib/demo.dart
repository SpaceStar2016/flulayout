import 'package:flutter/material.dart';


class ABC extends StatelessWidget {
  const ABC({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(58 / 3),
      ),
      child: LayoutBuilder(
          builder: (context,con) {
            return Row(
              children: [
                FlutterLogo(size: (100),),
                Column(
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
                              color: Colors.grey
                          ),
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
              ],
            );
          }
      ),
    );
  }
}

// class SceneScenario {
//
//   final String? author;
//
//   final String context;
//
//   final String? cover;
//
//
//   final String title;
//
//
//
//
//   SceneScenario({
//     required this.activities,
//     required this.context,
//     required this.cover,
//     required this.createAt,
//     required this.id,
//     required this.popularity,
//     required this.proficiency,
//     required this.tag,
//     required this.title,
//     required this.updateAt,
//     this.progress,
//     this.author,
//   });
//
//   factory SceneScenario.fromJson(Map<String, dynamic> json) =>
//       _$SceneScenarioFromJson(json);
//
//   Map<String, dynamic> toJson() => _$SceneScenarioToJson(this);
//
//   factory SceneScenario.fakeData(){
//     return SceneScenario(
//       activities: [],
//       context: "Learn the basics of Flutter development.",
//       cover: "https://foxay.cn/files/002024/0x5966320d76cf9c_N2Y1MTg4_如何破冰.jpg",
//       createAt: "2024-01-01T10:00:00Z",
//       id: "scenario-001",
//       popularity: 95,
//       proficiency: "A3",
//       tag: {"category": "development", "difficulty": "easy"},
//       title: "Introduction to Flutter",
//       updateAt: "2024-01-15T10:00:00Z",
//     );
//   }
// }
