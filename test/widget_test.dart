import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cardibee_flutter/app/app.dart';
import 'package:cardibee_flutter/core/storage/prefs_storage.dart';
import 'package:cardibee_flutter/mock/mock_module.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CardiBeeApp smoke test', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('app boots without throwing', (tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            prefsStorageProvider.overrideWithValue(PrefsStorage(prefs)),
            ...MockModule.overrides,
          ],
          child: const CardiBeeApp(),
        ),
      );

      // First pump renders the splash screen
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
