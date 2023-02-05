import 'package:buddy_swap/api/coin/coin-api.dart';
import 'package:buddy_swap/fiat/fiat_type.dart';
import 'package:buddy_swap/sell/create_sell_order_attribute.dart';
import 'package:buddy_swap/sell/sell_details_attribute.dart';
import 'package:buddy_swap/sell/sell_order_model.dart';
import 'package:buddy_swap/sell/sell_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../api/coin/rate.dart';
import '../crypto/crypto_types.dart';

class CreateSellOrderScreen extends StatefulWidget {
  const CreateSellOrderScreen({Key? key}) : super(key: key);

  @override
  State<CreateSellOrderScreen> createState() => _CreateSellOrderScreenState();
}

class _CreateSellOrderScreenState extends State<CreateSellOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final priceController = TextEditingController(text: "0.0");
  final amountController = TextEditingController(text: "0");
  late CryptoType selectedCryptoType;
  late FiatType selectedFiatType;
  bool _priceNumberError = false;
  bool _amountNumberError = false;
  CoinApi coinApi = CoinApi();
  double _priceSliderMin = 0;
  double _priceSliderMax = 100000;

  @override
  void initState() {
    super.initState();
    selectedCryptoType = CryptoType.values.first;
    selectedFiatType = FiatType.values.first;
    setDefaultPrice();
  }

  void cryptoTypeDropdownCallback(CryptoType? ct) {
    setState(() {
      selectedCryptoType = ct!;
    });
    setDefaultPrice();
  }

  void fiatTypeDropdownCallback(FiatType? ft) {
    setState(() {
      selectedFiatType = ft!;
    });
    setDefaultPrice();
  }

  Future<void> setDefaultPrice() async {
    Rate? rate = await coinApi.getData<Rate>(
        "/${selectedCryptoType.ticker}/${selectedFiatType.ticker}",
            (Map<String, dynamic> p0) => Rate.fromJson(p0));

    if (rate != null) {
      setSliderRange(rate.rate);
    }
  }

  void setSliderRange(double rate) {
    double range = rate.round() * 0.1;
    setState(() {
      priceController.text = rate.toString();
      _priceSliderMin = rate - range;
      _priceSliderMax = rate + range;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Create sell order"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  // filled: widget.filled ?? true,
                    hintText:
                    'Currency type',
                    labelText:
                    'Currency type',
                ),
                items: FiatType.values.map<DropdownMenuItem<FiatType>>(
                      (FiatType ft) {
                    return DropdownMenuItem<FiatType>(
                      value: ft,
                      child: Row(
                        children: [
                          Image.asset(
                            ft.logo,
                            height: 25,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(ft.displayName),
                        ],
                      ),
                    );
                  },
                ).toList(),
                onChanged: fiatTypeDropdownCallback,
                value: selectedFiatType,
                isExpanded: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  // filled: widget.filled ?? true,
                  hintText:
                  'Crypto type',
                  labelText:
                  'Crypto type',
                ),
                items: CryptoType.values.map<DropdownMenuItem<CryptoType>>(
                      (CryptoType ct) {
                    return DropdownMenuItem<CryptoType>(
                      value: ct,
                      child: Row(
                        children: [
                          Image.asset(
                            ct.logo,
                            height: 25,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(ct.displayName),
                        ],
                      ),
                    );
                  },
                ).toList(),
                onChanged: cryptoTypeDropdownCallback,
                value: selectedCryptoType,
                isExpanded: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  // filled: widget.filled ?? true,
                  hintText:
                  '${selectedFiatType.displayName} per ${selectedCryptoType
                      .displayName}',
                  labelText:
                  '${selectedFiatType.displayName} per ${selectedCryptoType
                      .displayName}',
                  errorText: _priceNumberError
                      ? "Please ensure price is a valid number"
                      : null,
                ),
                controller: priceController,
                onChanged: (value) {
                  setState(() {
                    if ((double.tryParse(value) != null) |
                    (int.tryParse(value) != null)) {
                      // setSliderRange(double.parse(value));
                      _priceNumberError = false;
                    } else {
                      _priceNumberError = true;
                    }
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [Text("-10%")],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [Text("-5%")],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [Text("+5%")],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [Text("+10%")],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    value: getSliderValue(),
                    onChanged: (getSliderValue() > _priceSliderMin &&
                        getSliderValue() < _priceSliderMax)
                        ? (value) {
                      setState(() {
                        priceController.text = value.toString();
                      });
                    }
                        : null,
                    min: _priceSliderMin,
                    max: _priceSliderMax,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  // filled: widget.filled ?? true,
                  hintText: 'Amount in ${selectedCryptoType.displayName}',
                  labelText: 'Amount in ${selectedCryptoType.displayName}',
                  errorText: _amountNumberError
                      ? "Please ensure price is a valid number"
                      : null,
                ),
                controller: amountController,
                onChanged: (value) {
                  setState(() {
                    if ((double.tryParse(value) != null) |
                    (int.tryParse(value) != null)) {
                      // setSliderRange(double.parse(value));
                      _amountNumberError = false;
                    } else {
                      _amountNumberError = true;
                    }
                  });
                },
              ),
            ),
            CreateSellOrderAttribute(
                label: "Total", value: selectedFiatType.denominator + getTotalPrice().toString()),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_priceNumberError == false &&
                        _amountNumberError == false) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      Provider.of<SellProvider>(context, listen: false).createSellOrder(double.parse(amountController.text), selectedCryptoType, double.parse(priceController.text), selectedFiatType);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sell order submitted")),
                      );
                      context.pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getTotalPrice() {
    if (double.tryParse(priceController.text) == null || double.tryParse(amountController.text) == null) {
      return 0.0;
    }
    return (double.parse(priceController.text) * double.parse(amountController.text));
  }

  double getSliderValue() =>
      (double.tryParse(priceController.text) != null &&
          between(double.tryParse(priceController.text), _priceSliderMin,
              _priceSliderMax))
          ? double.parse(priceController.text)
          : (_priceSliderMin + _priceSliderMax) / 2;

  bool between(double? value, double priceSliderMin, double priceSliderMax) {
    return value! > _priceSliderMin && value < _priceSliderMax;
  }
}
