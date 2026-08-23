import 'package:flutter/material.dart';
import 'package:nantib_chamnab_ticket_digital/app_theme.dart';

class CustomKhmerTabBar extends StatefulWidget {
  final List<String> tabs;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final List<Widget>? tabContents;
  final double fontSize;
  final Widget? Function(int index)? buildDayOne;
  final Widget? Function(int index)? buildDayTwo;

  const CustomKhmerTabBar({
    super.key,
    this.tabs = const ['ថ្ងៃទី១', 'ថ្ងៃទី២'],
    this.initialIndex = 0,
    this.onTabChanged,
    this.tabContents,
    this.fontSize = 16, this.buildDayOne, this.buildDayTwo,
  });

  @override
  State<CustomKhmerTabBar> createState() => _CustomKhmerTabBarState();
}

class _CustomKhmerTabBarState extends State<CustomKhmerTabBar> {
  late int selectedIndex;
  

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex.clamp(0, widget.tabs.length - 1);
  }

  void _setIndex(int index) {
    setState(() => selectedIndex = index);
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(widget.tabs.length, (index) {
            final isSelected = selectedIndex == index;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => _setIndex(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.lavender : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.tabs[index],
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        fontFamily: 'KHMEROSMUOLLIGHT',
                        color: isSelected ? AppTheme.primaryPurple : AppTheme.textDark,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 30),
        // If caller provided tabContents, show the selected one.
        if (widget.tabContents != null && widget.tabContents!.isNotEmpty)
          IndexedStack(
            index: selectedIndex.clamp(0, widget.tabContents!.length - 1),
            children: widget.tabContents!,
          )
        else
          // default placeholder for backward compatibility
          selectedIndex == 0
              ? widget.buildDayOne?.call(selectedIndex) ?? const SizedBox()
              : widget.buildDayTwo?.call(selectedIndex) ?? const SizedBox(),
      ],
    );
  }
}
