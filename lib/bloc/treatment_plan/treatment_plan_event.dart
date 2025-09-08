import '../../models/treatment_plan_models.dart';

abstract class TreatmentPlanEvent {
  const TreatmentPlanEvent();
}

class LoadTreatmentPlansSummary extends TreatmentPlanEvent {
  const LoadTreatmentPlansSummary();
}

class CreatePatientWithTreatment extends TreatmentPlanEvent {
  final PatientWithTreatmentCreate data;

  const CreatePatientWithTreatment(this.data);
}

class RefreshTreatmentPlansSummary extends TreatmentPlanEvent {
  const RefreshTreatmentPlansSummary();
}
