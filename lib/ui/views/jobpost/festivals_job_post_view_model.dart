import 'package:flutter/material.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';

class FestivalsJobPostViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  
  // Text Controllers
  late TextEditingController jobTitleController;
  late TextEditingController companyController;
  late TextEditingController locationController;
  late TextEditingController salaryController;
  late TextEditingController descriptionController;
  late TextEditingController requirementsController;
  late TextEditingController contactController;
  late TextEditingController festivalDateController;

  // Focus Nodes
  late FocusNode jobTitleFocusNode;
  late FocusNode companyFocusNode;
  late FocusNode locationFocusNode;
  late FocusNode salaryFocusNode;
  late FocusNode descriptionFocusNode;
  late FocusNode requirementsFocusNode;
  late FocusNode contactFocusNode;
  late FocusNode festivalDateFocusNode;

  // Job Type Selection
  String selectedJobType = 'Full-time';
  final List<String> jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Temporary',
    'Volunteer',
    'Internship',
  ];

  // Job Post Model
  JobPost? currentJobPost;

  FestivalsJobPostViewModel() {
    _initializeControllers();
    _initializeFocusNodes();
  }

  void _initializeControllers() {
    jobTitleController = TextEditingController();
    companyController = TextEditingController();
    locationController = TextEditingController();
    salaryController = TextEditingController();
    descriptionController = TextEditingController();
    requirementsController = TextEditingController();
    contactController = TextEditingController();
    festivalDateController = TextEditingController();
  }

  void _initializeFocusNodes() {
    jobTitleFocusNode = FocusNode();
    companyFocusNode = FocusNode();
    locationFocusNode = FocusNode();
    salaryFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
    requirementsFocusNode = FocusNode();
    contactFocusNode = FocusNode();
    festivalDateFocusNode = FocusNode();
  }

  void setJobType(String jobType) {
    selectedJobType = jobType;
    notifyListeners();
  }

  void unfocusAllFields() {
    jobTitleFocusNode.unfocus();
    companyFocusNode.unfocus();
    locationFocusNode.unfocus();
    salaryFocusNode.unfocus();
    descriptionFocusNode.unfocus();
    requirementsFocusNode.unfocus();
    contactFocusNode.unfocus();
    festivalDateFocusNode.unfocus();
  }

  bool _validateForm() {
    if (jobTitleController.text.trim().isEmpty) {
      _showError('Please enter a job title');
      jobTitleFocusNode.requestFocus();
      return false;
    }

    if (companyController.text.trim().isEmpty) {
      _showError('Please enter company/organization name');
      companyFocusNode.requestFocus();
      return false;
    }

    if (locationController.text.trim().isEmpty) {
      _showError('Please enter job location');
      locationFocusNode.requestFocus();
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      _showError('Please enter job description');
      descriptionFocusNode.requestFocus();
      return false;
    }

    if (contactController.text.trim().isEmpty) {
      _showError('Please enter contact information');
      contactFocusNode.requestFocus();
      return false;
    }

    if (festivalDateController.text.trim().isEmpty) {
      _showError('Please enter festival date');
      festivalDateFocusNode.requestFocus();
      return false;
    }

    return true;
  }

  void _showError(String message) {
    // You can implement a proper error handling mechanism here
    // For now, we'll just print to console
    debugPrint('Validation Error: $message');
  }

  void _showSuccess(String message) {
    // You can implement a proper success handling mechanism here
    debugPrint('Success: $message');
  }

  Future<void> postJob() async {
    if (!_validateForm()) {
      return;
    }

    await handleAsync(() async {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Create job post object
      currentJobPost = JobPost(
        title: jobTitleController.text.trim(),
        company: companyController.text.trim(),
        location: locationController.text.trim(),
        jobType: selectedJobType,
        salary: salaryController.text.trim(),
        description: descriptionController.text.trim(),
        requirements: requirementsController.text.trim(),
        contact: contactController.text.trim(),
        festivalDate: festivalDateController.text.trim(),
        postedDate: DateTime.now(),
        isActive: true,
      );

      // Here you would typically send the job post to your backend API
      // await _apiService.postJob(currentJobPost!);

      _showSuccess('Job posted successfully!');
      
      // Clear form after successful posting
      _clearForm();
      
      // Navigate back using NavigationService (MVVM compliant)
      _navigationService.pop();
      
    }, errorMessage: 'Failed to post job. Please try again.');
  }

  void _clearForm() {
    jobTitleController.clear();
    companyController.clear();
    locationController.clear();
    salaryController.clear();
    descriptionController.clear();
    requirementsController.clear();
    contactController.clear();
    festivalDateController.clear();
    selectedJobType = 'Full-time';
    notifyListeners();
  }

  @override
  void dispose() {
    // Dispose controllers
    jobTitleController.dispose();
    companyController.dispose();
    locationController.dispose();
    salaryController.dispose();
    descriptionController.dispose();
    requirementsController.dispose();
    contactController.dispose();
    festivalDateController.dispose();

    // Dispose focus nodes
    jobTitleFocusNode.dispose();
    companyFocusNode.dispose();
    locationFocusNode.dispose();
    salaryFocusNode.dispose();
    descriptionFocusNode.dispose();
    requirementsFocusNode.dispose();
    contactFocusNode.dispose();
    festivalDateFocusNode.dispose();

    super.dispose();
  }
}

class JobPost {
  final String title;
  final String company;
  final String location;
  final String jobType;
  final String salary;
  final String description;
  final String requirements;
  final String contact;
  final String festivalDate;
  final DateTime postedDate;
  final bool isActive;

  JobPost({
    required this.title,
    required this.company,
    required this.location,
    required this.jobType,
    required this.salary,
    required this.description,
    required this.requirements,
    required this.contact,
    required this.festivalDate,
    required this.postedDate,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'jobType': jobType,
      'salary': salary,
      'description': description,
      'requirements': requirements,
      'contact': contact,
      'festivalDate': festivalDate,
      'postedDate': postedDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      jobType: json['jobType'] ?? '',
      salary: json['salary'] ?? '',
      description: json['description'] ?? '',
      requirements: json['requirements'] ?? '',
      contact: json['contact'] ?? '',
      festivalDate: json['festivalDate'] ?? '',
      postedDate: DateTime.parse(json['postedDate'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
    );
  }
}
