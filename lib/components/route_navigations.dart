import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/route.dart';

class RouteNavigationRail extends ConsumerWidget {
  const RouteNavigationRail({
    super.key,
    required this.index,
    required this.routes,
  });

  final ValueNotifier<int> index;

  final List<Route> routes;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return SizedBox(
      width: 150,
      child: FadeInLeftBig(
        duration: const Duration(milliseconds: 200),
        // NavigationRail scrollable support.
        // NOTE: https://github.com/flutter/flutter/issues/89167
        // IntrinsicHeight <- is expensive.
        child: LayoutBuilder(
          builder: (final context, final constraint) {
            return Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraint.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: NavigationRail(
                          onDestinationSelected: (final value) =>
                              index.value = value,
                          labelType: NavigationRailLabelType.all,
                          destinations: [
                            for (final route in routes)
                              NavigationRailDestination(
                                icon: ZoomIn(child: route.icon),
                                label: Text(
                                  route.title,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                          selectedIndex: index.value,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
