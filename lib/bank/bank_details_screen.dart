import 'package:buddy_swap/bank/bank_details.dart';
import 'package:buddy_swap/bank/bank_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late BankType selectedBankType;
  late BankAccountType selectedBankAccountType;
  final branchCodeController = TextEditingController(text: "");
  final accountNumberController = TextEditingController(text: "");
  bool _branchCodeNotNumberError = false;
  bool _accountNotNumberError = false;

  void bankTypeDropdownCallback(BankType? bt) {
    setState(() {
      selectedBankType = bt!;
    });
  }

  void bankAccountTypeDropdownCallback(BankAccountType? bat) {
    setState(() {
      selectedBankAccountType = bat!;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedBankType = BankType.values.first;
    selectedBankAccountType = BankAccountType.values.first;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Bank details"),
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
                  'Select your bank',
                  labelText:
                  'Select your bank',
                ),
                items: BankType.values.map<DropdownMenuItem<BankType>>(
                      (BankType bt) {
                    return DropdownMenuItem<BankType>(
                      value: bt,
                      child: Row(
                        children: [
                          // Image.asset(
                          //   bt.logo,
                          //   height: 25,
                          // ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(bt.name),
                        ],
                      ),
                    );
                  },
                ).toList(),
                onChanged: bankTypeDropdownCallback,
                value: selectedBankType,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  // filled: widget.filled ?? true,
                  hintText: 'Bank branch code',
                  labelText: 'Bank branch code',
                  errorText: _branchCodeNotNumberError
                      ? "Please ensure branch number is a valid number"
                      : null,
                ),
                controller: branchCodeController,
                onChanged: (value) {
                  setState(() {
                    if ((double.tryParse(value) != null) |
                    (int.tryParse(value) != null)) {
                      // setSliderRange(double.parse(value));
                      _branchCodeNotNumberError = false;
                    } else {
                      _branchCodeNotNumberError = true;
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  // filled: widget.filled ?? true,
                  hintText:
                  'Select account type',
                  labelText:
                  'Select account type',
                ),
                items: BankAccountType.values.map<DropdownMenuItem<BankAccountType>>(
                      (BankAccountType bat) {
                    return DropdownMenuItem<BankAccountType>(
                      value: bat,
                      child: Row(
                        children: [
                          // Image.asset(
                          //   bt.logo,
                          //   height: 25,
                          // ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(bat.name),
                        ],
                      ),
                    );
                  },
                ).toList(),
                onChanged: bankAccountTypeDropdownCallback,
                value: selectedBankAccountType,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  // filled: widget.filled ?? true,
                  hintText: 'Account number',
                  labelText: 'Account number',
                  errorText: _accountNotNumberError
                      ? "Please ensure branch number is a valid number"
                      : null,
                ),
                controller: accountNumberController,
                onChanged: (value) {
                  setState(() {
                    if ((double.tryParse(value) != null) |
                    (int.tryParse(value) != null)) {
                      // setSliderRange(double.parse(value));
                      _accountNotNumberError = false;
                    } else {
                      _accountNotNumberError = true;
                    }
                  });
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_accountNotNumberError == false &&
                        _branchCodeNotNumberError == false) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      Provider.of<BankDetailsProvider>(context, listen: false).setBankDetails(BankDetails(selectedBankType, branchCodeController.text, selectedBankAccountType, accountNumberController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Bank account updated")),
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
}
