import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DayContainer extends StatelessWidget {
  final String day;
  final String date;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback onTap;

  const DayContainer({
    super.key,
    required this.day,
    required this.date,
    required this.isSelected,
    required this.isAvailable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ الخطوة 1: حساب العرض الديناميكي الصحيح
    // عرض الشاشة الكلي - (padding الـ sheet * 2) - (مجموع المسافات بين العناصر) / عدد العناصر
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding =
        30 * 2; // Padding الأفقي للـ BottomSheet (24 من كل جهة)
    const totalSpacing = 15 * 4; // 4 مسافات بين 5 عناصر (كل مسافة 15)
    final availableWidth = screenWidth - horizontalPadding - totalSpacing;
    final itemWidth = availableWidth / 5;

    final Color textColor = isAvailable
        ? (isSelected ? Colors.white : Colors.black)
        : Colors.grey.shade400;

    final Color borderColor = isAvailable
        ? (isSelected ? const Color(0xFF5C85D9) : const Color(0xFFD9D9D9))
        : Colors.grey.shade300;

    final Color containerColor = isSelected && isAvailable
        ? const Color(0xFF5C85D9)
        : Colors.transparent;

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        // ✅ الخطوة 2: تطبيق العرض الديناميكي المحسوب بدلاً من العرض الثابت
        width: itemWidth,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: containerColor, // لون الخلفية عند الاختيار
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: borderColor, width: 1.4),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              date,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
