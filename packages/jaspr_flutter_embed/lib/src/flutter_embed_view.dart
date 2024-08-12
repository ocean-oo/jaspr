import 'dart:html' as html;

import 'package:flutter/widgets.dart' as flt;
import 'package:jaspr/browser.dart';

import 'run_flutter_app.dart';

export 'run_flutter_app.dart' show ViewConstraints;

class FlutterEmbedView extends StatefulComponent {
  const FlutterEmbedView({
    this.app,
    this.loader,
    this.constraints,
    this.id,
    this.classes,
    this.styles,
    super.key,
  });

  final flt.Widget? app;
  final Component? loader;
  final ViewConstraints? constraints;
  final String? id;
  final String? classes;
  final Styles? styles;

  @override
  State<FlutterEmbedView> createState() => _FlutterEmbedViewState();
}

class _FlutterEmbedViewState extends State<FlutterEmbedView> {
  void Function()? rebuildFlutterApp;

  int? viewId;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      context.binding.addPostFrameCallback(() async {
        var element = findChildDomElement(context as Element)!;
        viewId = await addView(element, component.constraints, flt.StatefulBuilder(builder: (context, setState) {
          rebuildFlutterApp = () => setState(() {});
          return component.app ?? flt.SizedBox.shrink();
        }));
      });
    }
  }

  @override
  void dispose() {
    if (viewId != null) {
      removeView(viewId!);
    }
    super.dispose();
  }

  html.Element? findChildDomElement(Element element) {
    html.Node? node;
    element.visitChildren((child) {
      if (node != null) return;
      if (child is RenderObjectElement) {
        node = (child.renderObject as DomRenderObject).node as html.Element;
        return;
      } else {
        node = findChildDomElement(child);
      }
    });
    return node as html.Element?;
  }

  @override
  void didUpdateComponent(covariant FlutterEmbedView oldComponent) {
    super.didUpdateComponent(oldComponent);
    rebuildFlutterApp?.call();
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(
      id: component.id,
      classes: component.classes,
      styles: Styles.combine([
        if (component.constraints case final c?)
          Styles.box(
            minWidth: c.minWidth != double.infinity ? c.minWidth?.px : null,
            maxWidth: c.maxWidth != double.infinity ? c.maxWidth?.px : null,
            minHeight: c.minHeight != double.infinity ? c.minHeight?.px : null,
            maxHeight: c.maxHeight != double.infinity ? c.maxHeight?.px : null,
          ),
        if (component.styles != null) component.styles!
      ]),
      [
        if (component.loader != null && viewId == null) component.loader!,
      ],
    );
  }
}
