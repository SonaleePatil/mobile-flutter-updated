import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/adaptive_image.dart';
import 'listings_screen.dart';

class LivePostedScreen extends StatelessWidget {
  final String? title;
  final String? price;
  final String? imagePath;

  const LivePostedScreen({
    super.key,
    this.title,
    this.price,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,

      /// APPBAR
      appBar: AppBar(
        backgroundColor: AppColors.softCream,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.deepRed.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.deepRed,
                size: 20,
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Stack(
          children: [

            /// FRAME IMAGE (NO PADDING)
            Positioned(
               left: -32,
              top: 172,
              child: Image.asset(
                "assets/images/frame_1.png",
                width: 135,
                fit: BoxFit.contain,
              ),
            ),

            /// MAIN CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(height: 12),

                  /// TOP DECORATIVE CIRCLE
                 Center(
  child: ClipRRect(
    borderRadius: BorderRadius.circular(55),
    child: Image.asset(
      "assets/icons/checkmark.gif",
      width: 110,
      height: 110,
      fit: BoxFit.cover,
    ),
  ),
),

                  const SizedBox(height: 16),

                  /// TITLE
                  const Text(
  "Your item is live",
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

                  const SizedBox(height: 8),

                Text(
  "You have successfully\nposted listing",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

                  const SizedBox(height: 24),

                  /// LISTING CARD
                  Container(
                    width: 357,
                    height: 135,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDDA8),
                      borderRadius: BorderRadius.circular(20.7),
                      border: Border.all(
                        color: const Color(0xFFFFDDA8),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [

                        /// IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AdaptiveImage(
                            imagePath: imagePath ?? "assets/images/cycling_1.png",
                            width: 100.5,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 16),

               
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                            Text(
  title ?? "Untitled",
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

                              const SizedBox(height: 6),

                           Text(
  price ?? "",
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

                              const SizedBox(height: 6),

                            Text(
  "Posted by 2mins ago",
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark.withValues(alpha: 0.6),
  ),
),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                     label: "View Listing",
textStyle: const TextStyle(
  fontFamily: "Outfit",
  fontSize: 16,
  fontWeight: FontWeight.w500,
  height: 1.5, // 24px line height
  letterSpacing: 0,
),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListingsScreen(
                              imagePath: imagePath,
                            ),
                          ),
                        );
                      },
                      type: AppButtonType.primary,
                      backgroundColor: AppColors.deepRed,
                      textColor: Colors.white,
                      height: 50,
                      borderRadius: 10,
                    ),
                  ),

                  const SizedBox(height: 12),

             
                  AppButton(
                   label: "Post Another Item",
textStyle:  TextStyle(
  fontFamily: "Outfit",
  fontSize: 16,
  fontWeight: FontWeight.w500,
  height: 1.5, // 24px line height
  letterSpacing: 0,
color: AppColors.deepRed,
),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.white,
                    borderColor: AppColors.deepRed,
                    textColor: AppColors.deepRed,
                    height: 50,
                    borderRadius: 10,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}