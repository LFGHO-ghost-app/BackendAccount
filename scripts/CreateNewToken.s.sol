// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;
import {Script, console} from "forge-std/Script.sol";
import {FactoryAccountWallet} from "../src/FactoryAccountWallet.sol";

contract DeployTokenWallet is Script {
    function run() public returns (address account) {
        uint256 chainId = 11155111;
        address admin = 0x778F53F8549b2c198dc734cb59dfeDd437496499;
        FactoryAccountWallet factoryAccountWallet = FactoryAccountWallet(0x0A2965a37ffd53cDf6c168B64BC03eF70da772A0);
        bytes memory encodeData = encodeTokenData(chainId);
        return factoryAccountWallet.createAccount(admin, encodeData);
    }

    function encodeTokenData(uint256 chainId) public pure returns (bytes memory) {
        return abi.encode(chainId);
    }
}
