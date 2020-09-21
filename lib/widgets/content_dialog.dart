import 'dart:ui';

import 'package:flutter/material.dart';

class _ContentDialogImpl extends StatelessWidget {
  final Widget content;
  final bool transparent;
  final EdgeInsets padding;

  _ContentDialogImpl({
    @required Widget content,
    bool transparent,
    EdgeInsets padding,
  })  : content = content,
        transparent = transparent ?? false,
        padding = padding ?? EdgeInsets.all(15);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      backgroundColor: transparent ? Colors.transparent : null,
      child: Container(
        padding: padding,
        child: content,
      ),
    );
  }
}

class ContentDialog {
  static Future<void> show({
    @required BuildContext context,
    @required Widget content,
    bool transparent = false,
    EdgeInsets padding,
  }) async {
    var contentDialog = _ContentDialogImpl(
      content: content,
      transparent: transparent,
      padding: padding,
    );

    //await _showWithBlurredBackground(context: context, contentDialog: contentDialog);
    await _showWithShadedBackground(context: context, contentDialog: contentDialog);
  }

  static Future<void> _showWithShadedBackground({
    @required BuildContext context,
    @required _ContentDialogImpl contentDialog,
  }) async {
    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => contentDialog,
    );
  }

  static Future<void> _showWithBlurredBackground({
    @required BuildContext context,
    @required _ContentDialogImpl contentDialog,
  }) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      pageBuilder: (context, anim1, anim2) => contentDialog,
      transitionDuration: Duration(milliseconds: 100),
      transitionBuilder: (context, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2 * anim1.value, sigmaY: 2 * anim1.value),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: anim1,
            curve: Curves.easeOut,
          ),
          child: child,
        ),
      ),
    );
  }
}
