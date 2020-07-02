import 'package:chatappforweeb/utils/universal_variable.dart';
import 'package:chatappforweeb/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomTile(
      mini: false,
      onTap: () {},
      title: Text(
        "The CS Guy",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: Text(
        "hello",
        style: TextStyle(color: UniversalVariables.greyColor, fontSize: 14),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                  "https://yt3.ggpht.com/a/AGF-l7_zT8BuWwHTymaQaBptCy7WrsOD72gYGp-puw=s900-c-k-c0xffffffff-no-rj-mo"),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UniversalVariables.onlineDotColor,
                    border: Border.all(
                        color: UniversalVariables.blackColor, width: 2)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
