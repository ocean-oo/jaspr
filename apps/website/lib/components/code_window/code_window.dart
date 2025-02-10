import 'package:jaspr/jaspr.dart';
import 'package:website/constants/theme.dart';

import '../icon.dart';
import 'code_block.dart';

class CodeWindow extends StatelessComponent {
  CodeWindow({
    required this.name,
    this.inactiveName,
    required this.source,
    this.selectable = false,
    this.framed = true,
    this.lineClasses = const {},
    this.language = 'dart',
    this.scroll = true,
    super.key,
  });

  final String name;
  final String? inactiveName;
  final String source;
  final bool selectable;
  final bool framed;
  final String language;
  final bool scroll;
  final Map<int, String> lineClasses;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'code-window ${framed ? 'framed' : ''}', [
      div(classes: 'code-window-header', [
        div(classes: 'code-window-tab', [
          if (name.endsWith('.dart')) Icon('dart'),
          if (name.endsWith('.yaml')) Icon('file-json-2', size: 1.em),
          span(classes: 'code-window-title mono', [text(name)]),
        ]),
        if (inactiveName != null)
          div(classes: 'code-window-tab inactive', [
            if (inactiveName!.endsWith('.dart')) Icon('dart'),
            if (inactiveName!.endsWith('.yaml')) Icon('file-json-2', size: 1.em),
            span(classes: 'code-window-title mono', [text(inactiveName!)]),
          ]),
      ]),
      div(classes: 'code-window-body', [
        CodeBlock(source: source, selectable: selectable, lineClasses: lineClasses, language: language, scroll: scroll),
      ]),
    ]);
  }

  @css
  static final List<StyleRule> styles = [
    css('.code-window', [
      css('&').box(
        radius: BorderRadius.circular(13.px),
      ),
      css('&.framed', [
        css('&')
            .box(
              overflow: Overflow.hidden,
              border: Border.all(BorderSide(color: borderColor, width: 6.px)),
              shadow: BoxShadow(offsetX: 2.px, offsetY: 2.px, blur: 18.px, color: shadowColor1),
            )
            .background(color: borderColor),
      ]),
      css('&:not(.framed)', [
        css('.code-window-body').box(
          shadow: BoxShadow(offsetX: 2.px, offsetY: 2.px, blur: 10.px, color: shadowColor3),
        ),
      ]),
      css('.code-window-header', [
        css('&')
            .box(
              padding: EdgeInsets.only(left: 2.6.em, top: 2.px),
            )
            .flexbox(gap: Gap(column: 0.2.rem)),
        css('.code-window-tab', [
          css('&')
              .box(
                padding: EdgeInsets.only(left: .8.em, right: 1.2.em, top: .5.em, bottom: .5.em),
                shadow: BoxShadow(offsetX: 0.px, offsetY: (-2).px, blur: 3.px, color: shadowColor1),
                radius: BorderRadius.only(topLeft: Radius.circular(6.px), topRight: Radius.circular(6.px)),
              )
              .flexbox(alignItems: AlignItems.center, gap: Gap(column: 0.4.rem))
              .background(color: surfaceLowest)
              .text(color: textBlack),
          css('&.inactive')
              .box(opacity: 0.5, width: 0.px)
              .flexItem(flex: Flex(grow: 1))
              .raw({'max-width': 'fit-content'}),
        ]),
        css('.code-window-title').text(fontWeight: FontWeight.w400, fontSize: 0.9.rem),
      ]),
      css('.code-window-body', [
        css('&')
            .box(
              radius: BorderRadius.circular(8.px),
              overflow: Overflow.hidden,
              shadow: BoxShadow(offsetX: Unit.zero, offsetY: Unit.zero, blur: 4.px, color: shadowColor1),
            )
            .background(color: background),
      ]),
    ]),
  ];
}
