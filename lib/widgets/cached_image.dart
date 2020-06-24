import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String url;

  CachedImage({this.url});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ClipRect(
        child: CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, image)=> Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              )
            ),
          ),
          placeholder: (context, url) => Center(
            child: Container(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
