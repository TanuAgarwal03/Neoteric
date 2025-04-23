// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:


class BaseTabBar extends StatelessWidget {
  final TabController tabController;
  final Function(int index)? onTap;
  final List<Widget> tabList;
  final bool isScroll;
  const BaseTabBar({super.key,required this.tabController,this.onTap,required this.tabList,this.isScroll=false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: const Color(0xFFFEC3B4).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)
      ),
      child: TabBar(
        controller:tabController,
        isScrollable: isScroll,
        indicatorWeight: 0.01,
        padding: const EdgeInsets.all(5),
        labelPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFFF3601),
            boxShadow: const [BoxShadow(
              color: Colors.black38,
              offset: Offset(
                0.0,
                1.0,
              ),
              blurRadius: 2.0,
              spreadRadius: 0.0,
            )]
        ),
        onTap: onTap,
        labelColor: const Color(0xffFFFFFF),
        labelStyle: const TextStyle(color: Color(0xFFFF3601),fontSize: 14,fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(color: Color(0xFFFF3601),fontSize: 14,fontWeight: FontWeight.w400),
        unselectedLabelColor: const Color(0xFFFF3601),
        tabs: tabList,
      ),
    );
  }
}
