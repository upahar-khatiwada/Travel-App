import 'package:flutter/material.dart';

class InfoRowCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Color? titleColor;
  final Color? subtitleColor;

  const InfoRowCard({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        spacing: 12,
        children: <Widget>[
          leading,

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor ?? Theme.of(context).colorScheme.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: subtitleColor ??
                        Theme.of(context).colorScheme.secondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
