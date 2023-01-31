import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BoxItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function() onPress;
  const BoxItem(
      {super.key,
      required this.name,
      required this.icon,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF4B39EF),
            offset: Offset(
              0.1,
              0.1,
            ),
            blurRadius: 0.1,
            spreadRadius: 0.1,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: InkWell(
        onTap: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FaIcon(
                      icon,
                      color: const Color(0xFF4B39EF),
                      size: 20,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  name,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
    );
  }
}
