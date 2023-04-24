import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/state/loading_state.dart';
import '../../constants/color_constant.dart';

class LoaderButton extends StatelessWidget {
  final String btnText;
  final Color? textColor;
  final double? radius;
  final Color? borderSide;
  final double? textSize;
  final FontWeight? fontWeight;
  final Future<void> Function() onTap;
  final Color? color;

  const LoaderButton(
      {Key? key,
      required this.btnText,
      required this.onTap,
      this.color,
      this.fontWeight,
      this.textColor,
      this.textSize,
      this.radius,
      this.borderSide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.grey : Colors.grey,
          ),
        );
      },
    );
    return Consumer<LoadingState>(
      builder: (context, loadingButton, _) {
        return loadingButton.isLoading
            ? spinkit
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color ?? tabColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius ?? 0),
                    side: BorderSide(
                      color: borderSide ?? Colors.transparent,
                    ),
                  ),
                  minimumSize: Size(MediaQuery.of(context).size.width, 45),
                ),
                onPressed: () async {
                  try {
                    loadingButton.setLoading(true);
                    await onTap();
                    loadingButton.setLoading(false);
                  } catch (error) {
                    loadingButton.setLoading(false);
                  }
                },
                child: Text(
                  btnText,
                  style: TextStyle(
                      fontWeight: fontWeight ?? FontWeight.w800,
                      color: textColor ?? Colors.white,
                      fontSize: textSize ?? 16),
                ),
              );
      },
    );
  }
}
