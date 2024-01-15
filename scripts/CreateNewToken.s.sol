// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;
import {Script, console} from "forge-std/Script.sol";
import {FactoryAccountWallet} from "../src/FactoryAccountWallet.sol";

contract DeployTokenWallet is Script {
    function run() public returns (address account) {
        uint256 chainId = 11155111;
        address tokenAddress = 0xc4bF5CbDaBE595361438F8c6a187bDc330539c60;
        uint256 tokenId = 1;
        address admin = 0x778F53F8549b2c198dc734cb59dfeDd437496499;
        FactoryAccountWallet factoryAccountWallet = FactoryAccountWallet(0x6BF708dEb1056D6F134b126fc53EA72686aF9c70);
        bytes memory encodeData = encodeTokenData(chainId, tokenAddress, tokenId);
        return factoryAccountWallet.createAccount(admin, encodeData);
    }

    function encodeTokenData(
        uint256 chainId,
        address tokenAddress,
        uint256 tokenId
    ) public pure returns (bytes memory) {
        return abi.encode(chainId, tokenAddress, tokenId);
    }
}
