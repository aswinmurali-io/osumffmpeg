// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

import '../models/route.dart';

class RouteNavigationRail extends HookWidget {
  const RouteNavigationRail({
    super.key,
    required this.index,
    required this.routes,
    required this.onChanged,
  });

  final ValueNotifier<int> index;

  final List<Route> routes;

  final void Function() onChanged;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    return SizedBox(
      width: 150,
      child: FadeInLeftBig(
        duration: const Duration(milliseconds: 200),
        // NavigationRail scrollable support.
        // NOTE: https://github.com/flutter/flutter/issues/89167
        // IntrinsicHeight <- is expensive.
        child: LayoutBuilder(
          builder: (context, constraint) {
            return WebSmoothScroll(
              animationDuration: 300,
              scrollOffset: 80,
              controller: scrollController,
              child: Scrollbar(
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const NeverScrollableScrollPhysics(),
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
                            onDestinationSelected: (value) {
                              index.value = value;
                              onChanged();
                            },
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
              ),
            );
          },
        ),
      ),
    );
  }
}
