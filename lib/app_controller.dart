import 'package:flutter/material.dart';
import 'core/models/app_phase.dart';
import 'core/services/date_service.dart';
import 'core/services/storage_service.dart';

class AppController {
  // START IN LOADING PHASE
  final phaseNotifier = ValueNotifier<AppPhase>(AppPhase.loading);

  bool shouldPlayTransformation = false;

  void initialize() {
    // We don't determine the phase here anymore. 
    // We wait for the LoadingScreen to call onLoadingComplete.
  }

  // Called by LoadingScreen when assets are ready
  void onLoadingComplete() {
    final isTime = DateService.isValentines();
    final hasAccepted = StorageService.hasAccepted;

    if (hasAccepted) {
      if (isTime) {
        phaseNotifier.value = AppPhase.bouquet;
      } else {
        phaseNotifier.value = AppPhase.countdown;
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