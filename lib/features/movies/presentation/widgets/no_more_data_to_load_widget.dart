import '../../../../core/imports.dart';

class NoMoreDataToLoadWidget extends StatelessWidget {
  const NoMoreDataToLoadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 12).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            color: LightThemeColors.portraitMediumGrey,
          ),
          SizedBox(width: 10.w),
          Text(
            "No more data, to load",
            style: TextStyle(
              color: LightThemeColors.portraitMediumGrey,
                  
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}