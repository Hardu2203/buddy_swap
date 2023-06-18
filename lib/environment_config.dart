import 'package:buddy_swap/blockchain/ContractConfig.dart';
import 'package:enum_to_string/enum_to_string.dart';

class EnvironmentConfig {
  ContractAddress? contractAddress;
  static const coinApiKey = String.fromEnvironment('COIN_API_KEY');
  static const backendApiUrl = String.fromEnvironment('BACKEND_API');
  static const envProfile = String.fromEnvironment('ENVIRONMENT');

  static EnvironmentConfig? _instance;


  EnvironmentConfig(this.contractAddress);


  factory EnvironmentConfig.instance() {
    _instance ??= EnvironmentConfig._internal(ContractAddress(getContractAddressPath(
        EnumToString.fromString(EnvironmentEnum.values, envProfile) ??
            EnvironmentEnum.local)));
    return _instance!;
  }

  factory EnvironmentConfig._internal(ContractAddress contractAddress) {
    return EnvironmentConfig(contractAddress);
  }

  static String getAbi(ContractEnum contract) {
    switch (contract) {
      case ContractEnum.bank:
        return "${abiPath}TokenUserBanks.abi";
      case ContractEnum.wbtc:
        return "${abiPath}ERC20.abi";
      case ContractEnum.weth:
        return "${abiPath}ERC20.abi";
    }
  }

  static String getContractAddressPath(EnvironmentEnum env) {
    switch (env) {
      case EnvironmentEnum.local:
        return "${address}local.json";
    }
  }

  static const abiPath = "assets/smart-contracts/abi/";
  static const address = "assets/smart-contracts/address/";
}

enum ContractEnum { wbtc, weth, bank }

enum EnvironmentEnum {
  local,
}
