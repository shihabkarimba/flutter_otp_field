library flutter_otp_field;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget for entering OTP (One-Time password)
class FlutterOTPField extends StatefulWidget {
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final ButtonStyle? overlayButtonStyle;
  final TextStyle? overlayTextStyle;
  final Color? backroundColor;
  final TextStyle? textStyle;
  final double hieght;
  final Color? borderColor;
  final Color? focusedBgColor;
  final BoxBorder? focusedBorderStyle;
  final Color? unfocusedColor;
  final BoxBorder? unfocusedBorderStyle;
  final double borderWidth;
  final double borderRadius;
  final Color? indicatorColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formattes;
  final int length;
  const FlutterOTPField({
    super.key,
    this.overlayButtonStyle,
    this.overlayTextStyle,
    this.hieght = 55,
    this.textStyle,
    this.focusedBgColor,
    this.focusedBorderStyle,
    this.unfocusedColor,
    this.unfocusedBorderStyle,
    this.keyboardType,
    this.formattes,
    this.backroundColor,
    this.indicatorColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 6,
    this.onChanged,
    this.onCompleted,
    this.length = 6,
  });

  @override
  State<FlutterOTPField> createState() => _FlutterOTPFieldState();
}

class _FlutterOTPFieldState extends State<FlutterOTPField>
    with TickerProviderStateMixin {
  bool isFocused = false;
  late FocusNode focus;
  FocusNode f1 = FocusNode();
  var overlayController = OverlayPortalController();
  final controller = TextEditingController();
  var link = LayerLink();
  double x = 0;
  double y = 0;
  var formatters = <TextInputFormatter>[];

  Timer? t;
  bool isVisible = true;
  @override
  void initState() {
    focus = FocusNode(onKeyEvent: (node, event) {
      overlayController.hide();
      setState(() {
        isVisible = true;
      });
      return KeyEventResult.ignored;
    });
    focus.addListener(
      () {
        if (focus.hasPrimaryFocus) {
          t = Timer.periodic(
            const Duration(milliseconds: 500),
            (timer) {
              setState(() {
                isVisible = !isVisible;
              });
            },
          );
          setState(() {
            isFocused = true;
          });
        } else {
          overlayController.hide();
          t?.cancel();
          t = null;
          setState(() {
            isFocused = false;
          });
        }
      },
    );
    formatters = [
      ...widget.formattes ??
          [
          ],
      FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
      LengthLimitingTextInputFormatter(widget.length),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        final pos = details.globalPosition - details.localPosition;
        x = pos.dx;
        y = pos.dy;

        overlayController.show();
        focus.requestFocus();
        HapticFeedback.mediumImpact();
      },
      onTap: () {
        focus.requestFocus();
      },
      child: CompositedTransformTarget(
        link: link,
        child: OverlayPortal(
          controller: overlayController,
          overlayChildBuilder: (context) {
            return CompositedTransformFollower(
              link: link,
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: ElevatedButton(
                  style: widget.overlayButtonStyle ?? ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    shadowColor: Colors.black38,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -1,
                    ),
                  ),
                  onPressed: () async {
                    final clipboard =
                        await Clipboard.getData(Clipboard.kTextPlain);
                    var val = clipboard?.text.toString() ?? '';
                    for (final f in formatters) {
                      val = f
                          .formatEditUpdate(
                            const TextEditingValue(),
                            TextEditingValue(text: val),
                          )
                          .text;
                    }
                    controller.text = val;
                    if (val.length == widget.length &&
                        widget.onCompleted != null) {
                      widget.onCompleted!(val);
                    }
                    overlayController.hide();
                    focus.unfocus();
                  },
                  child: Text(
                    'Paste', style: widget.overlayTextStyle ?? const TextStyle(),
                  ),
                ),
              ),
            );
          },
          child: Stack(
            children: [
              SizedBox(
                height: widget.hieght + 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    widget.length,
                    (index) {
                      return Expanded(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            final pass = controller.text
                                .split('')
                                .map((e) => e)
                                .toList();

                            final isSame = (index == pass.length &&
                                index != widget.length);

                            final bool isFieldSame = ((isSame && isFocused) ||
                                (index == widget.length - 1 &&
                                    index == pass.length - 1));

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                height: widget.hieght,
                                decoration: BoxDecoration(
                                  color: isFieldSame
                                      ? widget.focusedBgColor
                                      : widget.unfocusedColor ?? widget.backroundColor ?? Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  border: isFieldSame
                                      ? widget.focusedBorderStyle
                                      : widget.unfocusedBorderStyle ??
                                          Border.all(
                                            color: widget.borderColor ??
                                                Colors.black12,
                                            width: widget.borderWidth,
                                          ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      index < pass.length ? pass[index] : '',
                                      style: widget.textStyle ??
                                          const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                          ),
                                    ),
                                    isFieldSame
                                        ? Container(
                                            height: 2,
                                            width: 14,
                                            color: isFocused && isVisible
                                                ? widget.indicatorColor ??
                                                    Colors.black
                                                : Colors.transparent,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Offstage(
                child: TextField(
                  autofocus: true,
                  focusNode: focus,
                  inputFormatters: formatters,
                  onChanged: (val) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(val);
                    }
                    if (val.length == widget.length &&
                        widget.onCompleted != null) {
                      focus.unfocus();
                      overlayController.hide();
                      widget.onCompleted!(val);
                    }
                  },
                  controller: controller,
                  keyboardType: widget.keyboardType ?? TextInputType.number,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
