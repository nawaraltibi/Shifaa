import 'package:flutter/material.dart';
import 'package:shifaa/features/appointments/presentation/manager/appointments_cubit.dart';
// import 'package:shifaa/features/appointments/presentation/manager/appointments_cubit.dart';

class ToggleAppointmentsType extends StatelessWidget {
  final AppointmentType selectedType;
  final ValueChanged<AppointmentType> onTypeChanged;

  const ToggleAppointmentsType({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildToggleItem(context, AppointmentType.upcoming, 'Upcoming'),
          _buildToggleItem(context, AppointmentType.previous, 'Previous'),
        ],
      ),
    );
  }

  Widget _buildToggleItem(BuildContext context, AppointmentType type, String text) {
    final bool isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTypeChanged(type),
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
            style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
