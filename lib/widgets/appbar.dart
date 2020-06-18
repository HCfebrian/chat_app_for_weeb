import 'package:chatappforweeb/utils/universal_variable.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> action;
  final Widget leading;
  final bool centerTitle;

  const CustomAppbar(
      {Key key, @required this.title, @required this.action, @required this.leading, @required this.centerTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: UniversalVariables.blackColor,
        border: Border(
          bottom: BorderSide(
            color: UniversalVariables.separatorColor,
            width: 1.4,
            style: BorderStyle.solid,
          )
        )
      ),
      child:  AppBar(
        backgroundColor:  UniversalVariables.blackColor,
          elevation: 0,
        leading: leading,
        centerTitle: centerTitle,
        actions: action,
        title: title,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  final Size preferredSize = const Size.fromHeight(kToolbarHeight+10) ;
}
