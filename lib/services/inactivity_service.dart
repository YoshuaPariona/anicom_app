// lib/services/inactivity_service.dart
import 'dart:async';
import 'package:flutter/material.dart';

/// Servicio para manejar la lógica de inactividad del usuario.
class InactivityService {
  Timer _timer = Timer(Duration.zero, () {});
  Timer _warningTimer = Timer(Duration.zero, () {});
  final VoidCallback onTimeout;
  final VoidCallback onWarningTimeout;
  final VoidCallback onInteraction;

  /// Crea una instancia de [InactivityService].
  ///
  /// [onTimeout] Callback que se ejecuta cuando se agota el tiempo de inactividad.
  /// [onWarningTimeout] Callback que se ejecuta cuando se muestra la advertencia de inactividad.
  /// [onInteraction] Callback que se ejecuta cuando hay una interacción del usuario.
  InactivityService({
    required this.onTimeout,
    required this.onWarningTimeout,
    required this.onInteraction,
  });

  /// Inicia el temporizador de inactividad.
  void start() {
    _timer.cancel(); // Cancela cualquier temporizador existente.
    _timer = Timer(const Duration(seconds: 30), () {
      onWarningTimeout();
      _warningTimer.cancel(); // Cancela cualquier temporizador de advertencia existente.
      _warningTimer = Timer(const Duration(seconds: 30), () {
        onTimeout();
      });
    });
  }

  /// Reinicia el temporizador de inactividad.
  void reset() {
    _timer.cancel();
    _warningTimer.cancel();
    start();
  }

  /// Cancela los temporizadores de inactividad.
  void cancel() {
    _timer.cancel();
    _warningTimer.cancel();
  }
}
