import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';

void showBubblePopup(BuildContext context, GlobalKey iconKey) {
  final overlay = Overlay.of(context);
  final renderBox = iconKey.currentContext!.findRenderObject() as RenderBox;
  final size = renderBox.size;
  final offset = renderBox.localToGlobal(Offset.zero);

  final List<String> notifications = [
    'yaser mcha yat3acha wakha feh jou3',
    'hello hello',
    'sf mal9it mangoul',
    'safe ride a7san projet fel maghrib hhh ',
    'kadaaaaaab',
    'yes 7it houwa a7san projet fel 3alam'
  ];

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (entry.mounted) entry.remove();
              },
            ),
          ),
          Positioned(
            top: offset.dy + size.height - 10,
            right:
                MediaQuery.of(context).size.width - offset.dx - size.width + 10,
            child: Material(
              color: Colors.transparent,
              child: IgnorePointer(
                ignoring: false,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.centerRight,
                      constraints: BoxConstraints(
                        minWidth: 200,
                        maxWidth: 250,
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      decoration: BoxDecoration(
                        color: c.lightColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: c.darkColor,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: notifications.isEmpty
                          ? Row(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    '../../../assets/images/notifications.png',
                                    height: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            )
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: notifications.map((text) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        color: c.darkColor,
                                        fontSize: 12,
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: CustomPaint(
                        size: const Size(10, 5),
                        painter: BubbleArrowPainter(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  overlay.insert(entry);

  Future.delayed(Duration(seconds: 15), () {
    if (entry.mounted) entry.remove();
  });
}

class BubbleArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = c.lightColor;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
