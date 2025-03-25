import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(HotReload());
}

class HotReload extends StatelessWidget {
  const HotReload({super.key});

  @override
  Widget build(BuildContext context) {
    final box00 = BoxConstraints();
    print('box000::${box00}-----${box00.maxHeight}');
    final box01 = BoxConstraints(minWidth: 0,maxWidth: 100,minHeight: 0,maxHeight: 100);
    print('box01::${box01}-----${box01.maxHeight}');
    final box02 = BoxConstraints(minWidth: 100,maxWidth: 0,minHeight: 100,maxHeight: 0);
    print('box02::${box02}');
    final box03 = BoxConstraints(minWidth: -10,maxWidth: 100,minHeight: 100,maxHeight: 0);
    print('box03::${box03}');

    double cRes00 = clampDouble(10,20,30);
    print('${cRes00}');

    double cRes01 = clampDouble(25,20,30);
    print('${cRes01}');

    double cRes02 = clampDouble(100,20,30);
    print('${cRes02}');

    final boxTightFor00 = BoxConstraints.tightFor();
    print('boxTightFor::${boxTightFor00}');

    final boxTightFor01 = BoxConstraints.tightFor(width: 100);
    print('boxTightFor::${boxTightFor01}');


    return const Placeholder();
  }
}