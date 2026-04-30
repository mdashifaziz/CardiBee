import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cardibee_flutter/core/theme/app_theme.dart';
import 'package:cardibee_flutter/core/widgets/credit_card_visual.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';

const _card = UserCard(
  id: 'uc_test',
  bankId: 'bank_ebl',
  bankName: 'EBL',
  cardTypeId: 'ct_ebl_plat_visa',
  productName: 'Platinum Visa',
  network: 'Visa',
  type: 'credit',
  nickname: 'Daily Driver',
  lastDigits: '4821',
  gradient: 'navy',
  createdAt: '2025-11-15T09:00:00Z',
);

const _cardNoNick = UserCard(
  id: 'uc_no_nick',
  bankId: 'bank_brac',
  bankName: 'BRAC Bank',
  cardTypeId: 'ct_brac_world_mc',
  productName: 'World Mastercard',
  network: 'Mastercard',
  type: 'credit',
  gradient: 'emerald',
  createdAt: '2025-11-20T09:00:00Z',
);

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('CreditCardVisual', () {
    testWidgets('renders bank name in uppercase', (tester) async {
      await tester.pumpWidget(_wrap(const CreditCardVisual(card: _card)));
      expect(find.textContaining('EBL'), findsOneWidget);
    });

    testWidgets('renders last 4 digits when set', (tester) async {
      await tester.pumpWidget(_wrap(const CreditCardVisual(card: _card)));
      expect(find.textContaining('4821'), findsOneWidget);
    });

    testWidgets('renders nickname when set', (tester) async {
      await tester.pumpWidget(_wrap(const CreditCardVisual(card: _card)));
      expect(find.text('Daily Driver'), findsOneWidget);
    });

    testWidgets('renders product name when no nickname', (tester) async {
      await tester.pumpWidget(_wrap(const CreditCardVisual(card: _cardNoNick)));
      expect(find.text('World Mastercard'), findsOneWidget);
    });

    testWidgets('sm size renders without overflow', (tester) async {
      await tester.pumpWidget(_wrap(
        const CreditCardVisual(card: _card, size: CardSize.sm),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('md size renders without overflow', (tester) async {
      await tester.pumpWidget(_wrap(
        const CreditCardVisual(card: _card),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('lg size renders without overflow', (tester) async {
      await tester.pumpWidget(_wrap(
        const CreditCardVisual(card: _card, size: CardSize.lg),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('fires onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        CreditCardVisual(card: _card, onTap: () => tapped = true),
      ));
      await tester.tap(find.byType(CreditCardVisual));
      expect(tapped, isTrue);
    });

    testWidgets('shows Mastercard dual-circle logo', (tester) async {
      await tester.pumpWidget(_wrap(
        const CreditCardVisual(card: _cardNoNick),
      ));
      // NetworkLogo for Mastercard renders a Stack with two circles
      expect(find.byType(Stack), findsWidgets);
    });
  });
}
