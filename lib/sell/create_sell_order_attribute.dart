import 'package:flutter/material.dart';

class CreateSellOrderAttribute extends StatelessWidget {
  final String label;
  final String value;

  const CreateSellOrderAttribute(
      {required this.label, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 0,
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
            child: Center(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // children: [
              child:  Text(value, style: Theme.of(context).textTheme.headline6),
              // ],
            ),
          ),
        ],
      ),
    );
  }
}
