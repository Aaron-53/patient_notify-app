import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/treatment_plan/treatment_plan_bloc.dart';
import '../bloc/treatment_plan/treatment_plan_event.dart';
import '../bloc/treatment_plan/treatment_plan_state.dart';
import '../models/patient_models.dart';
import '../models/treatment_plan_models.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  // Patient form controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Treatment plan form controllers
  final _upperTraysController = TextEditingController();
  final _lowerTraysController = TextEditingController();
  final _trayDurationController = TextEditingController(text: '10');

  DateTime? _selectedDob;
  String _selectedGender = 'M';
  DateTime? _treatmentStartDate;
  DateTime? _lastChangeDate;
  DateTime? _nextChangeDate;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _upperTraysController.dispose();
    _lowerTraysController.dispose();
    _trayDurationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDob == null ||
          _treatmentStartDate == null ||
          _lastChangeDate == null ||
          _nextChangeDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all date fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final patientData = PatientCreate(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        dob: _selectedDob!,
        gender: _selectedGender,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      final treatmentPlanData = TreatmentPlanCreate(
        totalUpperTrays: int.parse(_upperTraysController.text),
        totalLowerTrays: int.parse(_lowerTraysController.text),
        treatmentStartDate: _treatmentStartDate!,
        lastChangeDate: _lastChangeDate!,
        nextTrayChangeDate: _nextChangeDate!,
        trayDurationDays: int.parse(_trayDurationController.text),
      );

      final combinedData = PatientWithTreatmentCreate(
        patient: patientData,
        treatmentPlan: treatmentPlanData,
      );

      context.read<TreatmentPlanBloc>().add(
        CreatePatientWithTreatment(combinedData),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, String field) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        switch (field) {
          case 'dob':
            _selectedDob = picked;
            break;
          case 'treatmentStart':
            _treatmentStartDate = picked;
            break;
          case 'lastChange':
            _lastChangeDate = picked;
            break;
          case 'nextChange':
            _nextChangeDate = picked;
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Patient'),
        backgroundColor: Colors.blue.shade50,
      ),
      body: BlocListener<TreatmentPlanBloc, TreatmentPlanState>(
        listener: (context, state) {
          if (state is PatientWithTreatmentCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Patient added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/dashboard');
          } else if (state is TreatmentPlanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<TreatmentPlanBloc, TreatmentPlanState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Information Section
                    _buildSectionHeader('Patient Information'),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter patient name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _addressController,
                      label: 'Address',
                      icon: Icons.location_on,
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildDateField(
                      label: 'Date of Birth',
                      date: _selectedDob,
                      onTap: () => _selectDate(context, 'dob'),
                    ),
                    const SizedBox(height: 16),

                    _buildGenderField(),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Treatment Plan Section
                    _buildSectionHeader('Treatment Plan'),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _upperTraysController,
                            label: 'Upper Trays',
                            icon: Icons.medical_services,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Enter number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _lowerTraysController,
                            label: 'Lower Trays',
                            icon: Icons.medical_services,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Enter number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _trayDurationController,
                      label: 'Tray Duration (days)',
                      icon: Icons.timer,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter duration';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildDateField(
                      label: 'Treatment Start Date',
                      date: _treatmentStartDate,
                      onTap: () => _selectDate(context, 'treatmentStart'),
                    ),
                    const SizedBox(height: 16),

                    _buildDateField(
                      label: 'Last Change Date',
                      date: _lastChangeDate,
                      onTap: () => _selectDate(context, 'lastChange'),
                    ),
                    const SizedBox(height: 16),

                    _buildDateField(
                      label: 'Next Change Date',
                      date: _nextChangeDate,
                      onTap: () => _selectDate(context, 'nextChange'),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is TreatmentPlanCreateLoading
                            ? null
                            : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state is TreatmentPlanCreateLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Add Patient',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade400),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade400),
          ),
        ),
        child: Text(
          date != null
              ? '${date.day}/${date.month}/${date.year}'
              : 'Select date',
          style: TextStyle(color: date != null ? Colors.black87 : Colors.grey),
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: const InputDecoration(
        labelText: 'Gender',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'M', child: Text('Male')),
        DropdownMenuItem(value: 'F', child: Text('Female')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedGender = value;
          });
        }
      },
    );
  }
}
