import 'package:flutter/material.dart';

void main() {
  runApp(Center(child: Directionality(
    textDirection: TextDirection.ltr,
      child: ABC())));
}

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
          builder: (context,con00) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: con00.maxHeight > 400 ? 400 : con00.maxHeight,
                  maxHeight: con00.maxHeight,
                  minWidth: con00.minWidth,
                  maxWidth: con00.maxWidth),
              child: ColoredBox(
                color: Colors.yellow,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlutterLogo(size: (100),),
                    Spacer(),
                    Text('123123'),
                  ],
                ),
              ),
            );
          }
      ),
    );
    // return Container(
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(58 / 3),
    //   ),
    //   child: LayoutBuilder(
    //     builder: (context,con) {
    //       return ColoredBox(
    //         color: Colors.yellow,
    //         child: Row(
    //           // mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Column(
    //               children: [
    //                 Container(
    //                   color: Colors.black,
    //                   child: Row(
    //                     children: [
    //                       FlutterLogo(size: (100),),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       );
    //     }
    //   ),
    // );
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
