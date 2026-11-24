import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnia_app/state/app_state.dart';
import 'package:turnia_app/ui/screens/app_shell.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const TurniaAppRouter(),
    ),
  );
}