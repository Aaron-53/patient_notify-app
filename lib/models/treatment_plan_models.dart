import 'patient_models.dart';

class TreatmentPlan {
  final String id;
  final String patientId;
  final int totalUpperTrays;
  final int totalLowerTrays;
  final int currentUpperTray;
  final int currentLowerTray;
  final int traysDelivered;
  final DateTime treatmentStartDate;
  final DateTime lastChangeDate;
  final DateTime nextTrayChangeDate;
  final int trayDurationDays;

  const TreatmentPlan({
    required this.id,
    required this.patientId,
    required this.totalUpperTrays,
    required this.totalLowerTrays,
    required this.currentUpperTray,
    required this.currentLowerTray,
    required this.traysDelivered,
    required this.treatmentStartDate,
    required this.lastChangeDate,
    required this.nextTrayChangeDate,
    required this.trayDurationDays,
  });

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    return TreatmentPlan(
      id: json['id'],
      patientId: json['patient_id'],
      totalUpperTrays: json['total_upper_trays'],
      totalLowerTrays: json['total_lower_trays'],
      currentUpperTray: json['current_upper_tray'],
      currentLowerTray: json['current_lower_tray'],
      traysDelivered: json['trays_delivered'],
      treatmentStartDate: DateTime.parse(json['treatment_start_date']),
      lastChangeDate: DateTime.parse(json['last_change_date']),
      nextTrayChangeDate: DateTime.parse(json['next_tray_change_date']),
      trayDurationDays: json['tray_duration_days'],
    );
  }
}

class TreatmentPlanCreate {
  final int totalUpperTrays;
  final int totalLowerTrays;
  final int currentUpperTray;
  final int currentLowerTray;
  final int traysDelivered;
  final DateTime treatmentStartDate;
  final DateTime lastChangeDate;
  final DateTime nextTrayChangeDate;
  final int trayDurationDays;

  const TreatmentPlanCreate({
    required this.totalUpperTrays,
    required this.totalLowerTrays,
    this.currentUpperTray = 0,
    this.currentLowerTray = 0,
    this.traysDelivered = 0,
    required this.treatmentStartDate,
    required this.lastChangeDate,
    required this.nextTrayChangeDate,
    this.trayDurationDays = 10,
  });

  Map<String, dynamic> toJson() {
    return {
      'total_upper_trays': totalUpperTrays,
      'total_lower_trays': totalLowerTrays,
      'current_upper_tray': currentUpperTray,
      'current_lower_tray': currentLowerTray,
      'trays_delivered': traysDelivered,
      'treatment_start_date': treatmentStartDate.toIso8601String().split(
        'T',
      )[0],
      'last_change_date': lastChangeDate.toIso8601String().split('T')[0],
      'next_tray_change_date': nextTrayChangeDate.toIso8601String().split(
        'T',
      )[0],
      'tray_duration_days': trayDurationDays,
    };
  }
}

class PatientTreatmentSummary {
  final String name;
  final int totalUpperTrays;
  final int totalLowerTrays;
  final int upperTrayProgress;
  final int lowerTrayProgress;
  final DateTime nextChangeDate;

  const PatientTreatmentSummary({
    required this.name,
    required this.totalUpperTrays,
    required this.totalLowerTrays,
    required this.upperTrayProgress,
    required this.lowerTrayProgress,
    required this.nextChangeDate,
  });

  factory PatientTreatmentSummary.fromJson(Map<String, dynamic> json) {
    return PatientTreatmentSummary(
      name: json['name'],
      totalUpperTrays: json['total_upper_trays'],
      totalLowerTrays: json['total_lower_trays'],
      upperTrayProgress: json['upper_tray_progress'],
      lowerTrayProgress: json['lower_tray_progress'],
      nextChangeDate: DateTime.parse(json['next_change_date']),
    );
  }

  double get upperProgress =>
      totalUpperTrays > 0 ? upperTrayProgress / totalUpperTrays : 0.0;
  double get lowerProgress =>
      totalLowerTrays > 0 ? lowerTrayProgress / totalLowerTrays : 0.0;
}

class PatientWithTreatmentCreate {
  final PatientCreate patient;
  final TreatmentPlanCreate treatmentPlan;

  const PatientWithTreatmentCreate({
    required this.patient,
    required this.treatmentPlan,
  });

  Map<String, dynamic> toJson() {
    return {
      'patient': patient.toJson(),
      'treatment_plan': treatmentPlan.toJson(),
    };
  }
}

class PatientWithTreatmentResponse {
  final Patient patient;
  final TreatmentPlan treatmentPlan;

  const PatientWithTreatmentResponse({
    required this.patient,
    required this.treatmentPlan,
  });

  factory PatientWithTreatmentResponse.fromJson(Map<String, dynamic> json) {
    return PatientWithTreatmentResponse(
      patient: Patient.fromJson(json['patient']),
      treatmentPlan: TreatmentPlan.fromJson(json['treatment_plan']),
    );
  }
}
