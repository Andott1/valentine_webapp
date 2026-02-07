import 'package:flutter/material.dart';
import 'core/models/app_phase.dart';
import 'core/services/date_service.dart';
import 'core/services/storage_service.dart';

class AppController {
  final phaseNotifier = ValueNotifier<AppPhase>(AppPhase.loading);
  bool shouldPlayTransformation = false;

  void initialize() {
    // Initialization logic is handled by LoadingScreen calling onLoadingComplete
  }

  // NEW: Helper to check where we are going before we get there
  AppPhase get initialPhase {
    final isTime = DateService.isValentines();
    final hasAccepted = StorageService.hasAccepted;

    if (hasAccepted) {
      if (isTime) {
        return AppPhase.bouquet;
      } else {
        return AppPhase.countdown;
      }
    } else {
      return AppPhase.proposal;
    }
  }

  void onLoadingComplete() {
    // Use the same logic to actually switch the phase
    phaseNotifier.value = initialPhase;

    // Logic for playing the entrance animation if we just arrived at bouquet
    if (initialPhase == AppPhase.bouquet && 
        StorageService.lastTransformationDate != DateService.todayString()) {
      shouldPlayTransformation = true;
      StorageService.setLastTransformationDate(DateService.todayString());
    }
  }

  void acceptProposal() async {
    await StorageService.setAccepted(true);
  }

  void transitionAfterProposal() {
    if (DateService.isValentines()) {
      shouldPlayTransformation = true;
      phaseNotifier.value = AppPhase.bouquet;
    } else {
      phaseNotifier.value = AppPhase.countdown;
    }
  }

  void debugTestBouquet() {
    shouldPlayTransformation = true;
    phaseNotifier.value = AppPhase.bouquet;
  }
}