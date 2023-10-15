import 'dart:ffi';

import 'package:buddy_swap/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/apis/core/core.dart';
import 'package:walletconnect_flutter_v2/apis/core/pairing/utils/pairing_models.dart';
import 'package:walletconnect_flutter_v2/apis/models/basic_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/json_rpc_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/proposal_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/session_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/sign_client_events.dart';
import 'package:walletconnect_flutter_v2/apis/utils/namespace_utils.dart';
import 'package:walletconnect_flutter_v2/apis/web3app/i_web3app.dart';
import 'package:walletconnect_flutter_v2/apis/web3app/web3app.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_connect.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';
import '../../api/backend/backend-api.dart';
import '../../environment_config.dart';
import '../../user/user_model.dart';
import 'auth_functions.dart';

class ProdMobileAuthFunctions extends ChangeNotifier implements AuthFunctions {
  IWalletConnectModalService? _walletConnectModalService;

  IWeb3App? _web3App;

  bool _initialized = false;

  String? _chainId;
  String? _account;

  final String _chainIdCurrent = "eip155:1697260901251";

  @override
  Future<String?> sendTransaction(ContractEnum contractEnum, String functionName, List<dynamic> parameters) async {
    final contract = await _getContract(contractEnum);
    final fun = contract.function(functionName);

    final transaction = Transaction.callContract(
      contract: contract,
      function: fun,
      parameters: parameters,
      from: EthereumAddress.fromHex(_account!),
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 1000000,
    );

    //widget.web3App.sessions.getAll().first;
    //widget.session.topic
    Future tx = _web3App!.request(
      topic: _web3App!.sessions.getAll().first.topic,
      chainId: _chainId!,
      request: SessionRequestParams(
        method: 'eth_sendTransaction',
        // Check the `web3dart_extension` file for this function
        params: [transaction.toJson(fromAddress: _account)],
      ),
    );

    _walletConnectModalService!.launchCurrentWallet();
    String waited = await tx;
    return waited;
  }

  @override
  Future<Widget> initializeWeb3(BuildContext context) async {
    _web3App = Web3App(
      core: Core(
        projectId: EnvironmentConfig.projectId,
      ),
      metadata: const PairingMetadata(
        name: 'Flutter Dapp Example',
        description: 'Flutter Dapp Example',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );

    Function(SessionConnect?) onConnect = createOnConnectHandler(context);
    _web3App!.onSessionConnect.subscribe(onConnect);

    Function(SessionDelete?) onDisconnect = createOnDisconnectHandler(context);
    _web3App!.onSessionDelete.subscribe(onDisconnect);

    await _web3App?.init();

    _walletConnectModalService = WalletConnectModalService(
      web3App: _web3App,
      recommendedWalletIds: {
        'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96',
        // MetaMask
        '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0',
        // Trust
      },
      // excludedWalletState: ExcludedWalletState.all,
    );

    // widget.web3App.onSessionDelete.subscribe(_onWeb3AppDisconnect);

    final Map<String, RequiredNamespace> requiredNamespaces = {};
    await _walletConnectModalService?.init();

    requiredNamespaces['eip155'] = RequiredNamespace(
      chains: [_chainIdCurrent],
      methods: [
        'personal_sign',
        'eth_signTypedData',
        'eth_sendTransaction',
      ],
      events: [
        'chainChanged',
        'accountsChanged',
      ],
    );

    _walletConnectModalService?.setRequiredNamespaces(
        requiredNamespaces: requiredNamespaces);


    return WalletConnectModalConnect(service: _walletConnectModalService!);
  }

  WalletConnectModalConnect initWeb3Handlers(BuildContext context) {


    return WalletConnectModalConnect(service: _walletConnectModalService!);
  }

  @override
  signMessage(String nonce) async {
    checkChainId();
    Future signed = _web3App!.request(
      topic: _web3App!.sessions.getAll().first.topic,
      chainId: getChainId()!,
      request: SessionRequestParams(
        method: 'personal_sign',
        params: [nonce, _account],
      ),
    );
    _walletConnectModalService!.launchCurrentWallet();
    String waited = await signed;
    return waited;
  }

  Future<DeployedContract> _getContract(ContractEnum contract) async {
    String abi =
        await rootBundle.loadString(EnvironmentConfig.getAbi(contract));
    // await _wallet.metamaskConnect(); //Request metamask connection (May not be necessary at this stage)

    final _contract = DeployedContract(
        ContractAbi.fromJson(abi, EnvironmentConfig.getContractName(contract)),
        EthereumAddress.fromHex(
            EnvironmentConfig.getContractAddress(contract)));

    return _contract;
  }

  @override
  Future<UserModel> getPublicKey([UserModel? user]) {
    if (_account == null) {
      SessionData session = _web3App!.sessions.getAll().first;
      // Get all of the accounts
      final List<String> namespaceAccounts = [];

      // Loop through the namespaces, and get the accounts
      for (final Namespace namespace in session.namespaces.values) {
        namespaceAccounts.addAll(namespace.accounts);
      }

      _account = NamespaceUtils.getAccount(
        namespaceAccounts.first,
      );
    }

    return Future(() => UserModel("anon", _account!));
  }

  Function(SessionConnect?) createOnConnectHandler(BuildContext context) {
    return (SessionConnect? args) async {
        print('connected');

        checkChainId();

        await Provider.of<BackendApi>(context, listen: false).login();
        if (context.mounted) {
          GoRouter.of(context).go('/sell');
        } else {
          print('not mounted');
      }
    };
  }



  void checkChainId() {
    for (final Namespace namespace in _web3App!.sessions.getAll().first.namespaces.values) {
      namespace.accounts.forEach((element) {
        String chainId = NamespaceUtils.getChainFromAccount(element);
        if (_chainIdCurrent != chainId) {
          print('Update chainId to $chainId');
        }
      });
    }
  }

  Function(SessionDelete?) createOnDisconnectHandler(BuildContext context) {
    return (SessionDelete? args) async {
      print('disconnected');
      Provider.of<BackendApi>(context, listen: false).logout();
      GoRouter.of(context).go('/login');
    };
  }

  getChainId() {
    if (_chainId == null) {
      SessionData session = _web3App!.sessions.getAll().first;
      // Get all of the accounts
      final List<String> namespaceAccounts = [];

      // Loop through the namespaces, and get the accounts
      for (final Namespace namespace in session.namespaces.values) {
        namespaceAccounts.addAll(namespace.accounts);
      }

    _chainId = NamespaceUtils.getChainFromAccount(
        namespaceAccounts.first,
      );
    }
    return _chainId!;
  }

  @override
  bool isWeb3Connected() {
    if (_web3App == null) return false;
    return (_web3App!.sessions.getAll().isNotEmpty);
  }

  @override
  logout() {
    _walletConnectModalService?.disconnect();
  }
}

extension TransactionX on Transaction {
  Map<String, dynamic> toJson({
    String? fromAddress,
  }) {
    return {
      'from': fromAddress ?? from?.hex,
      'to': to?.hex,
      'gas': maxGas != null ? '0x${maxGas!.toRadixString(16)}' : null,
      'gasPrice': '0x${gasPrice?.getInWei.toRadixString(16) ?? '0'}',
      'value': '0x${value?.getInWei.toRadixString(16) ?? '0'}',
      'data': data != null ? bytesToHex(data!) : null,
      'nonce': nonce,
    };
  }
}
