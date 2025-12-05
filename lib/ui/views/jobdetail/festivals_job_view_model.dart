import 'package:festival_rumour/core/viewmodels/base_view_model.dart';
import 'package:flutter/material.dart';

class FestivalsJobViewModel extends BaseViewModel {
  final List<Job> jobs = [
    Job(
      title: "Audiovisual Technician",
      description:
      "Audiovisual technician. National average salary: \$61,782 per year. Duties: Audiovisual technicians operate the audio and visual systems and equipment...",
    ),
    Job(
      title: "Event Accreditation Staff",
      description:
      "Event staff supervisors, event arena supervisors, event organizers, event accreditation staff, and office managers...",
    ),
  ];
}

class Job {
  final String title;
  final String description;

  Job({required this.title, required this.description});
}
