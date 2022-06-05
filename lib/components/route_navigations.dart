import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/routes.dart';

class RouteNavigationRail extends ConsumerWidget {
  const RouteNavigationRail({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final routeIndex = ref.watch(RouteProvider.provider);
    final routeNotifier = ref.watch(RouteProvider.provider.notifier);

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
                              routeNotifier.route = value,
                          labelType: NavigationRailLabelType.all,
                          destinations: [
                            for (final route in RouteProvider.routes)
                              NavigationRailDestination(
                                icon: ZoomIn(child: route.icon),
                                label: Text(
                                  route.title,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                          selectedIndex: routeIndex,
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
