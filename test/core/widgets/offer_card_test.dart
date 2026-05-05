import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cardibee_flutter/core/theme/app_theme.dart';
import 'package:cardibee_flutter/core/widgets/offer_card_widget.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';

const _testOffer = Offer(
  id: 'test_offer_1',
  merchantId: 'mer_test',
  merchantName: "Sultan's Dine",
  merchantInitial: 'SD',
  category: 'Food',
  title: '20% off on total bill',
  discountLabel: '20% OFF',
  description: 'Test description',
  validFrom: '2026-01-01',
  validUntil: '2026-11-30',
  daysLeft: 5,
  bannerStart: '#F97316',
  bannerEnd: '#E11D48',
);

const _testOfferNotExpiring = Offer(
  id: 'test_offer_2',
  merchantId: 'mer_aarong',
  merchantName: 'Aarong',
  merchantInitial: 'A',
  category: 'Shopping',
  title: '15% off on apparel',
  discountLabel: '15% OFF',
  description: 'Test',
  validFrom: '2026-01-01',
  validUntil: '2026-12-31',
  daysLeft: 60,
  bannerStart: '#DC2626',
  bannerEnd: '#F59E0B',
);

Widget _wrap(Widget child) => ProviderScope(
  child: MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  ),
);

void main() {
  group('OfferCardWidget — default variant', () {
    testWidgets('renders merchant name', (tester) async {
      await tester.pumpWidget(_wrap(OfferCardWidget(offer: _testOffer)));
      expect(find.text("Sultan's Dine"), findsOneWidget);
    });

    testWidgets('renders discount label', (tester) async {
      await tester.pumpWidget(_wrap(OfferCardWidget(offer: _testOffer)));
      expect(find.text('20% OFF'), findsOneWidget);
    });

    testWidgets('shows expiring-soon badge when daysLeft <= 7', (tester) async {
      await tester.pumpWidget(_wrap(OfferCardWidget(offer: _testOffer)));
      expect(find.textContaining('d left'), findsOneWidget);
    });

    testWidgets('shows valid-until text when not expiring soon', (tester) async {
      await tester.pumpWidget(_wrap(OfferCardWidget(offer: _testOfferNotExpiring)));
      expect(find.textContaining('Until'), findsOneWidget);
    });

    testWidgets('shows favorite heart icon', (tester) async {
      await tester.pumpWidget(_wrap(OfferCardWidget(offer: _testOffer)));
      expect(
        find.byIcon(Icons.favorite_rounded).evaluate().isNotEmpty ||
        find.byIcon(Icons.favorite_border_rounded).evaluate().isNotEmpty,
        isTrue,
      );
    });
  });

  group('OfferCardWidget — featured variant', () {
    testWidgets('renders discount label', (tester) async {
      await tester.pumpWidget(_wrap(
        OfferCardWidget(offer: _testOffer, variant: OfferCardVariant.featured),
      ));
      expect(find.text('20% OFF'), findsOneWidget);
    });

    testWidgets('renders category badge', (tester) async {
      await tester.pumpWidget(_wrap(
        OfferCardWidget(offer: _testOffer, variant: OfferCardVariant.featured),
      ));
      expect(find.text('Food'), findsOneWidget);
    });

    testWidgets('renders without overflow', (tester) async {
      await tester.pumpWidget(_wrap(
        OfferCardWidget(offer: _testOffer, variant: OfferCardVariant.featured),
      ));
      expect(tester.takeException(), isNull);
    });
  });
}
