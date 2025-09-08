import 'package:flutter/material.dart';
import '../models/treatment_plan_models.dart';

class PatientSummaryCard extends StatelessWidget {
  final PatientTreatmentSummary patient;

  const PatientSummaryCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Name and Next Appointment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getNextAppointmentColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _formatNextAppointment(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Upper Tray Progress
            _buildProgressSection(
              'Upper Trays',
              patient.upperTrayProgress,
              patient.totalUpperTrays,
              patient.upperProgress,
              Colors.blue,
            ),
            const SizedBox(height: 12),

            // Lower Tray Progress
            _buildProgressSection(
              'Lower Trays',
              patient.lowerTrayProgress,
              patient.totalLowerTrays,
              patient.lowerProgress,
              Colors.green,
            ),
            const SizedBox(height: 16),

            // Next Change Date
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Next change: ${_formatDate(patient.nextChangeDate)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(
    String title,
    int current,
    int total,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              '$current/$total',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  Color _getNextAppointmentColor() {
    final daysUntil = patient.nextChangeDate.difference(DateTime.now()).inDays;
    if (daysUntil < 0) {
      return Colors.red; // Overdue
    } else if (daysUntil <= 2) {
      return Colors.orange; // Due soon
    } else if (daysUntil <= 7) {
      return Colors.amber; // Due this week
    } else {
      return Colors.green; // Future
    }
  }

  String _formatNextAppointment() {
    final daysUntil = patient.nextChangeDate.difference(DateTime.now()).inDays;
    if (daysUntil < 0) {
      return '${-daysUntil} days overdue';
    } else if (daysUntil == 0) {
      return 'Due today';
    } else if (daysUntil == 1) {
      return 'Due tomorrow';
    } else if (daysUntil <= 7) {
      return 'Due in $daysUntil days';
    } else {
      return 'Due in $daysUntil days';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
