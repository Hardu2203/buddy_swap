import 'package:buddy_swap/sell/sell_details_attribute.dart';
import 'package:buddy_swap/sell/sell_order_model.dart';
import 'package:buddy_swap/sell/sell_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SellDetailsScreen extends StatelessWidget {
  final int index;

  const SellDetailsScreen({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    SellOrderModel sellOrder =
        Provider.of<SellProvider>(context).sellOrders[index];
    return Scaffold(
      appBar: AppBar(
        title: Text("Sell Details $index"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: deviceSize.height * 0.05,
          ),
          SellDetailsAttribute(label: "Price", value: sellOrder.priceString),
          SellDetailsAttribute(label: "Amount", value: sellOrder.cryptoAmountString),
          SellDetailsAttribute(label: "Status", value: sellOrder.statusDisplayName.toString()),
          SellDetailsAttribute(label: "Owner", value: sellOrder.owner),
          // SizedBox(width: deviceSize.width * 0.2,),
          // Text("Price: ", style: Theme.of(context).textTheme.headline6),
          // Text(sellOrder.priceString, style: Theme.of(context).textTheme.headline6),
          const Spacer(),
          ElevatedButton(
              child: const Text("View on blockchain"),
              onPressed: () {
                const SnackBar(content: Text("TODO"),);
          }
          ),
          SizedBox(
            height: deviceSize.height * 0.05,
          ),
        ],
      ),
    );
  }
}
