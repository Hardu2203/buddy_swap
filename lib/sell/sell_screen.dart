import 'dart:io';

import 'package:buddy_swap/auth/auth_provider.dart';
import 'package:buddy_swap/bank/bank_details_provider.dart';
import 'package:buddy_swap/constants.dart';
import 'package:buddy_swap/crypto/crypto_types.dart';
import 'package:buddy_swap/environment_config.dart';
import 'package:buddy_swap/fiat/fiat_type.dart';
import 'package:buddy_swap/sell/sell_details_attribute.dart';
import 'package:buddy_swap/sell/sell_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:web3dart/credentials.dart';

import '../bank/bank_splash_screen.dart';

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
      body: Consumer2<SellProvider, BankDetailsProvider>(
        builder: (context, sellProvider, bankProvider, child) {
          return Stack(
            children: [
              // if (!bankProvider.isSet())
              //   const BankSplashScreen()
              // else
              sellProvider.sellOrders.isEmpty
                  ? emptySellOrdersSplash(deviceSize, context)
                  : buildListView(sellProvider),
              if (bankProvider.isSet())
                createProvideBankDetailsButton(context)
              else
                createSellOrderButton(context),
            ],
          );
        },
      ),
    );
  }

  Column createSellOrderButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Center(
          child: ElevatedButton(
              onPressed: () async {
                // context.go("/sell/create");
                var result =
                    await Provider.of<SellProvider>(context, listen: false)
                        .createSellOrder(20, CryptoType.bitcoin, 200, FiatType.zar);
                // await Provider.of<AuthProvider>(context, listen: false)
                //     .sendTransaction(ContractEnum.wbtc, "approve", [EthereumAddress.fromHex(kEnv.contractAddress.bank), BigInt.from(70)]);

                // print(result);
              },
              child: const Text("deposit")),
        ),
      ],
    );
  }

  Column createProvideBankDetailsButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Center(
            child: ElevatedButton(
                onPressed: () {
                  // Provider.of<SellProvider>(context, listen: false)
                  //     .createSellOrder();
                  context.go("/settings/bank");
                },
                child: const Text("Bank details")),
          ),
        ),
      ],
    );
  }

  Column emptySellOrdersSplash(Size deviceSize, BuildContext context) {
    return Column(
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
        Expanded(
            child: Text("Create your first sell order",
                style: GoogleFonts.permanentMarker(
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.color
                            ?.withOpacity(0.5))))),
      ],
    );
  }

  ListView buildListView(SellProvider sellProvider) {
    return ListView.builder(
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
              height: 50,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                sellProvider.deleteSellOrder(index);
              },
            ),
            title: listTileAttribute('Price:', sellOrder.priceString),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                listTileAttribute('Amount:', sellOrder.cryptoAmountString),
                SizedBox(height: 4),
                listTileAttribute(
                    'Total:',
                    sellOrder.fiatType.denominator +
                        (sellOrder.cryptoAmount * sellOrder.price).toString()),
              ],
            ),
            onTap: () {
              context.go('/sell/$index');
            },
          );
        });
  }

  Widget listTileAttribute(String label, String value) {
    return Row(
      children: [
        Container(width: 60, child: Text(label)),
        SizedBox(
          width: 8,
        ),
        Text(value)
      ],
    );
  }
}
