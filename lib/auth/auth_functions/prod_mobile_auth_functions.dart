

import 'package:flutter/services.dart';
import 'package:http/src/client.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';
import '../../user/user_model.dart';
import 'auth_functions.dart';

class ProdMobileAuthFunctions implements AuthFunctions {
  String? _uri;
  SessionStatus? _session;
  // final Web3Client ethereum = Web3Client('https://ropsten.infura.io/', Client());
  final Web3Client ethereum = Web3Client('https://goerli.infura.io/v3/a2965691a60d4c11ac887ded53d7fe86', Client());

  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'Swappi Swap',
          description: 'An awesome exchange',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  @override
  Future<UserModel> getPublicKey([UserModel? user]) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        _session = session;
        return UserModel("anon", _session!.accounts[0]);
      } catch (exp) {
        print(exp);
        throw Error();
      }
    } else return UserModel("anon", _session!.accounts[0]);

    throw Error();
  }

  @override
  Future<String?> signMessage(String message) async {
    if (connector.connected) {
      try {
        print("Message received");
        print(message);

        EthereumWalletConnectProvider provider =
            EthereumWalletConnectProvider(connector);
        launchUrlString(_uri!, mode: LaunchMode.externalApplication);
        var signature = await provider.personalSign(
            message: message, address: _session!.accounts[0], password: "");
        print(signature);
        return signature;
      } catch (exp) {
        print("Error while signing transaction");
        print(exp);
      }
    }
    return null;
  }

  Future<String?> sendTransaction() async {
    final theContract = await _getContract();
    final fun = theContract.function('approve');

    final transaction = Transaction.callContract(
      contract: theContract,
      function: fun,
      parameters: [
        EthereumAddress.fromHex('0x1B9De33Cf41Bd6b8d1D06d5185655a22e7Fc3448'),
        BigInt.from(70)
      ],
      from:
          EthereumAddress.fromHex('0x47f7Aa90bBD05944c0553Cf36B39c539a95291b9'),
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 100000,
    );

    EthereumWalletConnectProvider provider =
        EthereumWalletConnectProvider(connector);

    getPublicKey();

    final credentials = WalletConnectEthereumCredentials(provider: provider);

    launchUrlString(_uri!, mode: LaunchMode.externalApplication);

    // var signature = await provider.signTransaction(
    //     from: '0x47f7Aa90bBD05944c0553Cf36B39c539a95291b9',
    //     to: theContract.address.hex,
    //     gas: 41000,
    //     gasPrice: BigInt.from(0),
    //     nonce: 1,
    //     data: transaction.data);

    final txBytes = await ethereum.sendTransaction(credentials, transaction);

    return 'nice';
  }

  Future<DeployedContract> _getContract() async {
    String abi = await rootBundle.loadString(
      "assets/smart-contracts/abi/ERC20.abi",
    );
    // await _wallet.metamaskConnect(); //Request metamask connection (May not be necessary at this stage)

    final _contract = DeployedContract(ContractAbi.fromJson(abi, "WBTC"),
        EthereumAddress.fromHex('0x26FD312fb8A8F2CED0aBa1A19e2cE7Be18982856'));

    return _contract;
  }
}

class WalletConnectEthereumCredentials extends CustomTransactionSender {
  WalletConnectEthereumCredentials({required this.provider});

  final EthereumWalletConnectProvider provider;

  @override
  Future<EthereumAddress> extractAddress() {
    // TODO: implement extractAddress
    throw UnimplementedError();
  }

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    final hash = await provider.sendTransaction(
      from: transaction.from!.hex,
      to: transaction.to?.hex,
      data: transaction.data,
      gas: transaction.maxGas,
      gasPrice: transaction.gasPrice?.getInWei,
      value: transaction.value?.getInWei,
      nonce: transaction.nonce,
    );

    return hash;
  }


  @override
  // TODO: implement address
  EthereumAddress get address => throw UnimplementedError();

  @override
  MsgSignature signToEcSignature(Uint8List payload, {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToEcSignature
    throw UnimplementedError();
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload, {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToSignature
    throw UnimplementedError();
  }

}