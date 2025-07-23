import 'package:flutter/material.dart';

class ToggleSearchType extends StatefulWidget {
  const ToggleSearchType({super.key});

  @override
  State<ToggleSearchType> createState() => _ToggleSearchTypeState();
}

class _ToggleSearchTypeState extends State<ToggleSearchType> {
  int _selectedIndex = 1; 

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildToggleItem(0, 'Doctors'),
          _buildToggleItem(1, 'Specialties'),
        ],
      ),
    );
  }

  Widget _buildToggleItem(int index, String text) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)]
                : [],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

