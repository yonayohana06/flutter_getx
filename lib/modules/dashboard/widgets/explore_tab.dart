import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.explore_outlined, size: 64),
          const SizedBox(height: AppDimensions.md),
          Text('Explore', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'Your explore content goes here',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
