import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.icon,
    required this.name,
    this.trailing,
    this.onClick,
    this.textTheme,
    this.iconColor,
  });

  final IconData icon;
  final String name;
  final Widget? trailing;
  final VoidCallback? onClick;
  final TextStyle? textTheme;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 4),
              Text(
                name,
                style: textTheme ??
                    Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Expanded(child: SizedBox()),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
