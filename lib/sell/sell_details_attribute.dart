import 'package:flutter/material.dart';

class SellDetailsAttribute extends StatelessWidget {
  final String label;
  final String value;

  const SellDetailsAttribute(
      {required this.label, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: deviceSize.width * 0.1,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("$label: ",
                    style: Theme.of(context).textTheme.headline6),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: Theme.of(context).textTheme.headline6),
              ],
            ),
          ),
          SizedBox(
            width: deviceSize.width * 0.1,
          ),
        ],
      ),
    );
  }
}
