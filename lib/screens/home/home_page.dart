import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bottom_nav.dart';
import '../../data/viewModel/HomeViewModel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            body: viewModel.pages[viewModel.selectedIndex],
            bottomNavigationBar: BottomNavBar(
              currentIndex: viewModel.selectedIndex,
              onTap: (index) => viewModel.changeTab(index),
            ),
          );
        },
      ),
    );
  }
}
