import 'dart:io';

import 'package:buddy_swap/constants.dart';
import 'package:buddy_swap/crypto/crypto_types.dart';
import 'package:buddy_swap/fiat/fiat_type.dart';
import 'package:buddy_swap/sell/sell_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  @override
  void initState() {
    super.initState();
    fetchSellOrders();
  }

  Future<void> fetchSellOrders() {
    return Future.delayed(
        Duration.zero,
        () => setState(() {
              Provider.of<SellProvider>(context, listen: false)
                  .loadSellOrders();
            }));
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sell",
            style: GoogleFonts.permanentMarker(
                textStyle: Theme.of(context).textTheme.titleLarge)),
      ),
      body: Consumer<SellProvider>(
        builder: (context, sellProvider, child) {
          return Stack(
            children: [
              sellProvider.sellOrders.isEmpty
                  ? Column(
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.all(deviceSize.width * 0.02),
                            // color: Colors.pink,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                opacity: 0.5,
                                image: Svg(kUndrawEmpty),
                              ),
                            ),
                          ),
                      ),
                      Expanded(child: Text("Create your first sell order", style: GoogleFonts.permanentMarker(
                          textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.5))))),
                    ],
                  )
                  : ListView.builder(
                      itemCount: sellProvider.sellOrders.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // return Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text(
                        //       "Title: " + providerItem.basketItem[index].title),
                        // );
                        var sellOrder = sellProvider.sellOrders[index];
                        return ListTile(
                          leading: Image.asset(
                            sellOrder.cryptoType.logo,
                            height: 40,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Theme.of(context).errorColor, onPressed: () {
                              sellProvider.deleteSellOrder(index);
                          },
                          ),
                          title: Text(sellOrder.priceString),
                          subtitle: Text(
                            sellOrder.cryptoAmountString,
                          ),
                          onTap: () {
                            context.go('/sell/$index');
                          },
                        );
                      }),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          // Provider.of<SellProvider>(context, listen: false)
                          //     .createSellOrder();
                          context.go("/sell/create");
                        },
                        child: const Text("Create sell order")),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
