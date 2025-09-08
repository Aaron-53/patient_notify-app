import '../../models/treatment_plan_models.dart';

abstract class TreatmentPlanState {
  const TreatmentPlanState();
}

class TreatmentPlanInitial extends TreatmentPlanState {
  const TreatmentPlanInitial();
}

class TreatmentPlanLoading extends TreatmentPlanState {
  const TreatmentPlanLoading();
}

class TreatmentPlansSummaryLoaded extends TreatmentPlanState {
  final List<PatientTreatmentSummary> patients;

  const TreatmentPlansSummaryLoaded(this.patients);
}

class PatientWithTreatmentCreated extends TreatmentPlanState {
  final PatientWithTreatmentResponse response;
  final List<PatientTreatmentSummary> updatedPatients;

  const PatientWithTreatmentCreated(this.response, this.updatedPatients);
}

class TreatmentPlanError extends TreatmentPlanState {
  final String message;

  const TreatmentPlanError(this.message);
}

class TreatmentPlanCreateLoading extends TreatmentPlanState {
  const TreatmentPlanCreateLoading();
}
