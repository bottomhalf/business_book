import 'package:business_book/widgets/Cards/blur_cards.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoDashboardCard extends StatelessWidget {
  Function reloadPage;

  InfoDashboardCard({this.reloadPage});

  Widget bindContext() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "User:",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                  ),
                  Text(
                    "Second line",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        FontAwesomeIcons.archway,
                        color: Colors.white,
                        size: 18,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'Folder (10)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        FontAwesomeIcons.calendar,
                        color: Colors.white,
                        size: 18,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'Visited: 10:00 PM',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        InkWell(
          onTap: reloadPage,
          child: Container(
            height: 20,
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Click to reload page.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  FontAwesomeIcons.redoAlt,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlurCards(
        content: bindContext(),
      ),
    );
  }
}
