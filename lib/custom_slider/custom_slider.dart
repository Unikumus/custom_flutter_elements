import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomSlider extends LeafRenderObjectWidget {
  final Color sliderColor;
  final double start;
  final double end;
  final TextStyle? textStyle;

  const CustomSlider({
    Key? key,
    required this.sliderColor,
    required this.start,
    required this.end,
    this.textStyle,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMySlider(sliderColor: sliderColor, start: start, end: end, textStyle: textStyle);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderMySlider renderObject) {
    renderObject.sliderColor = sliderColor;
  }
}

class RenderMySlider extends RenderBox {
  final double start;
  final double end;
  final TextStyle? textStyle;

  RenderMySlider({
    required Color sliderColor,
    required this.start,
    required this.end,
    this.textStyle,
  }) : _sliderColor = sliderColor {
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = (DragStartDetails details) {
        _updateThumbPosition(details.localPosition);
      }
      ..onUpdate = (DragUpdateDetails details) {
        _updateThumbPosition(details.localPosition);
      };
  }

  Color get sliderColor => _sliderColor;
  Color _sliderColor;

  double _currentThumbValue = 0.0;

  set sliderColor(Color value) {
    if (_sliderColor == value) {
      return;
    }
    _sliderColor = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    final desiredWidth = constraints.maxWidth;
    final desiredHeight = constraints.maxHeight;
    final desiredSize = Size(desiredWidth, desiredHeight);

    size = constraints.constrain(desiredSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();

    canvas.translate(offset.dx, offset.dy);

    final lValue = (100 / size.width) * _currentThumbValue / 100;

    Color? gC = ColorTween(begin: Colors.grey, end: sliderColor).lerp(lValue);

    final sliderPaint = Paint()
      ..strokeWidth = 5
      ..color = gC!;

    final thumbPaint = Paint()
      ..strokeWidth = 5
      ..color = gC
      ..style = PaintingStyle.stroke;

    final thumbDx = _currentThumbValue;
    final thumbRadius = size.height / 2;

    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(
        thumbDx <= thumbRadius ? 0 : (thumbDx - thumbRadius).clamp(0, size.width - thumbRadius * 2), size.height / 2);

    // draw line
    canvas.drawLine(point1, point2, sliderPaint);

    // draw thumb
    final thumbCenter = Offset(thumbDx.clamp(thumbRadius, size.width - thumbRadius), thumbRadius);
    canvas.drawCircle(thumbCenter, size.height / 2, thumbPaint);

    final title = (thumbCenter.dx - (thumbRadius)) * (100 / (size.width - thumbRadius * 2));

    // draw text
    final defTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 10,
    );
    final textSpan = TextSpan(
      text: title.toStringAsFixed(1),
      style: textStyle ?? defTextStyle,
    );
    final textPainter = TextPainter(
      textAlign: TextAlign.left,
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final fontHeigth = (textStyle ?? defTextStyle).fontSize;

    final offset1 = Offset(thumbCenter.dx - (textPainter.width / 2), thumbCenter.dy / 2 + fontHeigth! / 4);
    textPainter.paint(canvas, offset1);
  }

  late HorizontalDragGestureRecognizer _drag;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }

  @override
  void dispose() {
    _drag.dispose();
    super.dispose();
  }

  void _updateThumbPosition(Offset localPosition) {
    double dx = localPosition.dx.clamp(0, size.width);
    _currentThumbValue = dx;

    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }
}