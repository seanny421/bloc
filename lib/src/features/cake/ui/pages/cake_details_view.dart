import 'package:cake_it_app/src/features/cake/data/cake.dart';
import 'package:cake_it_app/src/features/cake/ui/widgets/cake_image.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a cake.
class CakeDetailsView extends StatelessWidget {
  final Cake cake;
  const CakeDetailsView({
    required this.cake,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            foregroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(cake.title,
                  style: const TextStyle(
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                  )),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CakeImage(
                    imageUrl: cake.image,
                    width: double.infinity,
                  ),
                  const DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black87
                    ],
                    stops: [0.0, 0.5, 1.0],
                  )))
                ],
              ),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 1.5,
                        ),
                  ),
                  Center(
                    child: Text(cake.description),
                  ),
                  //Below is just to show the parallax effect
                  const SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                    style: TextStyle(height: 1.6),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Serving Suggestions',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
                    style: TextStyle(height: 1.6),
                  ),
                  const Text(
                    'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
                    style: TextStyle(height: 1.6),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
