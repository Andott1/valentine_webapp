import 'package:flutter/material.dart';
import 'core/models/app_phase.dart';
import 'core/services/date_service.dart';
import 'core/services/storage_service.dart';

class AppController {
  final phaseNotifier = ValueNotifier<AppPhase>(AppPhase.proposal);

  bool shouldPlayTransformation = false;

  void initialize() {
    final isTime = DateService.isValentines();
    final hasAccepted = StorageService.hasAccepted;

    if (hasAccepted) {
      if (isTime) {
        phaseNotifier.value = AppPhase.bouquet;
      } else {
        phaseNotifier.value = AppPhase.countdown; // Go to timer
      }
    } else {
      phaseNotifier.value = AppPhase.proposal;
    }
    
    // Logic for playing the entrance animation if we just arrived at bouquet
    if (isTime && StorageService.lastTransformationDate != DateService.todayString()) {
      shouldPlayTransformation = true;
      StorageService.setLastTransformationDate(DateService.todayString());
    }
  }

  void acceptProposal() async {
    await StorageService.setAccepted(true);
    // We don't change phase immediately here anymore.
    // The UI (ProposalScreen) will handle the Confetti -> Phase Change transition.
  }

  void transitionAfterProposal() {
    if (DateService.isValentines()) {
      shouldPlayTransformation = true;
      phaseNotifier.value = AppPhase.bouquet;
    } else {
      phaseNotifier.value = AppPhase.countdown;
    }
  }

  // --- ADD THIS DEBUG METHOD ---
  void debugTestBouquet() {
    shouldPlayTransformation = true; // Force the animation to play
    phaseNotifier.value = AppPhase.bouquet;
  }
}