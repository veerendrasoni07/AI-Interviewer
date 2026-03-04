import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/view/screens/home_screen.dart';
import 'package:frontend/view/screens/pricing_screen.dart';
import 'package:frontend/view/screens/profile_screen.dart';
import 'package:frontend/view/screens/session_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class InnerMainScreen extends StatefulWidget {
  InnerMainScreen({super.key});

  @override
  State<InnerMainScreen> createState() => _InnerMainScreenState();
}

class _InnerMainScreenState extends State<InnerMainScreen> {
  int selectedScreen = 1;

  final screens = [
    HomeScreen(),
    PricingScreen(),
    ReportScreen(),
    ProfileScreen()
  ];
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  double _scale = 1.0;

  void _reset() {
    setState(() {
      _rotateX = 0;
      _rotateY = 0;
      _scale = 1;
    });
  }
  @override
  void initState() {
    super.initState();
  }

  void onPageChanged(int index){
    if(selectedScreen == index) return;
    setState(() {
      selectedScreen = index;
    });
  }
  void _onItemTapped(int index) {
    if (selectedScreen == index) return;
    setState(() {
      selectedScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[selectedScreen],
      bottomNavigationBar: SafeArea(child: _buildGlassNavBar()) ,
    );
  }

  Widget _buildGlassNavBar() {
    return GestureDetector(
      onPanEnd: (_) => _reset(),
      onPanCancel: _reset,
      onPanUpdate: (details){
        final box = context.findRenderObject() as RenderBox;
        final local = box.globalToLocal(details.globalPosition);

        final dx = local.dx - box.size.width / 2;
        final dy = local.dy - box.size.height / 2;

        final nx = (dx / (box.size.width / 2)).clamp(-1.0, 1.0);
        final ny = (dy / (box.size.height / 2)).clamp(-1.0, 1.0);
        setState(() {
          _rotateY = nx * 0.18;     // controlled rotation
          _rotateX = -ny * 0.18;
          _scale = 1.05;
        });
      },
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        builder: (context,s,child){
          return Transform(
            alignment: Alignment.center,
            transform:  Matrix4.identity()..setEntry(3, 2, 0.0006)..rotateX(_rotateX)..rotateY(_rotateY)..scale(_scale),
            child: child,
          );
        },
          child: Container(
            height: 70,
            margin: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 0, 93, 49),
                  const Color.fromARGB(255, 33, 255, 141)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 1, 120, 5),
                  blurRadius: 4,
                  spreadRadius: 2
                )
              ]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                children: [
                  //Frosted Blur
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: const SizedBox(),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: _navItem(Icon(Icons.home_outlined, size: 20,color: Colors.white,), Icon(Icons.home_rounded, size: 20,color: Colors.white,), 0,"Home")),
                        Expanded(child: _navItem(Icon(Icons.monetization_on_outlined, size: 20,color: Colors.white,), Icon(Icons.monetization_on_rounded,size: 20,color: Colors.white,), 1,"Pricing")),
                        Expanded(child: _navItem(Icon(Icons.library_books_outlined, size: 20,color: Colors.white,), Icon(Icons.library_books_rounded,color: Colors.white,size: 20), 2,"Report")),
                        Expanded(child: _navItem(Icon(Icons.person_2_outlined, size: 20,color: Colors.white,), Icon(Icons.person_4_rounded,color: Colors.white,size: 20), 3,"Profile")),

                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
      ),
    );
  }

  Widget _navItem(Icon inactive, Icon activeIcon, int index,String title) {
    final isActive = selectedScreen == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 10,
              )
            ]

          ),
          duration: const Duration(milliseconds: 350),
          child:Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: isActive
                  ? Row(
                key: const ValueKey('active'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  activeIcon,
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style:  GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 10,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
                  : inactive,
            ),)
      ),
    );
  }
}
