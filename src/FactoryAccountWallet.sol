// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions
//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.23;

import {BaseAccountFactory, IEntryPoint} from "@thirdweb-dev/contracts/prebuilts/account/utils/BaseAccountFactory.sol";
import {AccountWallet} from "./AccountWallet.sol";

contract FactoryAccountWallet is BaseAccountFactory {
    constructor(
        IEntryPoint _entrypoint
    )
        BaseAccountFactory(
            address(new AccountWallet(_entrypoint, address(this))),
            address(_entrypoint)
        )
    {}

    function _generateSalt(
        address,
        bytes memory _data
    ) internal view virtual override returns (bytes32) {
        return keccak256(abi.encode(_data));
    }

    function _initializeAccount(
        address account,
        address admin,
        bytes calldata data
    ) internal override {
        AccountWallet(payable(account)).initialize(admin, data);
    }
}
