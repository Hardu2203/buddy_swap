import 'package:buddy_swap/api/coin/coin-api.dart';
import 'package:buddy_swap/fiat/fiat_type.dart';
import 'package:flutter/material.dart';

import '../api/coin/rate.dart';
import '../crypto/crypto_types.dart';

class CreateSellOrderScreen extends StatefulWidget {
  const CreateSellOrderScreen({Key? key}) : super(key: key);

  @override
  State<CreateSellOrderScreen> createState() => _CreateSellOrderScreenState();
}

class _CreateSellOrderScreenState extends State<CreateSellOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController(text: "0.0");
  late CryptoType selectedCryptoType;
  late FiatType selectedFiatType;
  bool _errorState1 = false;
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
      double range = rate.rate.round() * 0.1;
      setState(() {
        myController.text = rate.rate.toString();
        _priceSliderMin = rate.rate - range;
        _priceSliderMax = rate.rate + range;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      '${selectedFiatType.displayName} per ${selectedCryptoType.displayName}',
                  labelText:
                      '${selectedFiatType.displayName} per ${selectedCryptoType.displayName}',
                  errorText: _errorState1
                      ? "Any entry without an 'a' will trigger this error"
                      : null,
                ),
                controller: myController,
                onChanged: (value) {
                  setState(() {
                    if (value.contains('a') | value.isEmpty) {
                      _errorState1 = false;
                    } else {
                      _errorState1 = true;
                    }
                  });
                },
              ),
            ),
            Slider(
              value: double.parse(myController.text),
              onChanged: (value) {
                setState(() {
                  myController.text = value.toString();
                });
              },
              min: _priceSliderMin,
              max: _priceSliderMax,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(myController.text)),
                      );
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
}
