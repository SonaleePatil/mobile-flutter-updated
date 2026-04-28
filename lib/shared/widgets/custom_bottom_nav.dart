import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.deepRed,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
  _navItem("assets/icons/bottom_home.png", 0),
  _navItem("assets/icons/add_calendar.png", 1),
  _navItem("assets/svg/bottom_comm.svg", 2, isSvg: true),
  _navItem("assets/svg/bottom_pro.svg", 3, isSvg: true),
],
          ),
        ),
      ),
    );
  }
Widget _navItem(String iconPath, int index, {bool isSvg = false}) {
  final bool isSelected = currentIndex == index;

  return GestureDetector(
    onTap: () => onTap(index),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       isSvg
    ?SvgPicture.asset(
  iconPath,
  height: 25,
  width: 25,
  colorFilter: ColorFilter.mode(
    isSelected ? Colors.white : Colors.white.withOpacity(0.5),
    BlendMode.srcIn,
  ),
)
    : Image.asset(
        iconPath,
        height: 25,
        width: 25,
        color: isSelected
            ? Colors.white
            : Colors.white.withOpacity(0.5),
        colorBlendMode: BlendMode.srcIn,
      ),

        const SizedBox(height: 6),

        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? 12 : 0,
          height: 2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ],
    ),
  );
}
}