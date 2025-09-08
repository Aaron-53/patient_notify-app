import '../../models/treatment_plan_models.dart';

abstract class PatientEvent {
  const PatientEvent();
}

class LoadPatientsSummary extends PatientEvent {
  const LoadPatientsSummary();
}

class CreatePatientWithTreatment extends PatientEvent {
  final PatientWithTreatmentCreate data;

  const CreatePatientWithTreatment(this.data);
}

class RefreshPatientsSummary extends PatientEvent {
  const RefreshPatientsSummary();
}
