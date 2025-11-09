import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_tim_tro/app.dart';

void main() {
  testWidgets('App khởi chạy', (WidgetTester tester) async {
    await tester.pumpWidget(const TimTroApp());
    expect(find.text('Trang chủ'), findsNothing);
  });
}
