import '../../models/treatment_plan_models.dart';

abstract class PatientState {
  const PatientState();
}

class PatientInitial extends PatientState {
  const PatientInitial();
}

class PatientLoading extends PatientState {
  const PatientLoading();
}

class PatientsSummaryLoaded extends PatientState {
  final List<PatientTreatmentSummary> patients;

  const PatientsSummaryLoaded(this.patients);
}

class PatientCreated extends PatientState {
  final PatientWithTreatmentResponse response;
  final List<PatientTreatmentSummary> updatedPatients;

  const PatientCreated(this.response, this.updatedPatients);
}

class PatientError extends PatientState {
  final String message;

  const PatientError(this.message);
}

class PatientCreateLoading extends PatientState {
  const PatientCreateLoading();
}
