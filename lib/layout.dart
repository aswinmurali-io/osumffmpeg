import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/route_navigations.dart';
import 'models/routes.dart';

class OsumMainPage extends ConsumerWidget {
  const OsumMainPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final routeIndex = ref.watch(RouteProvider.provider);

    return Scaffold(
      body: Row(
        children: [
          const RouteNavigationRail(),
          Expanded(
            child: Center(
              child: RouteProvider.routes[routeIndex].page,
            ),
          )
        ],
      ),
    );
  }
}
