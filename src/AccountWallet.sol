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

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@thirdweb-dev/contracts/eip/interface/IERC721.sol";
import {Account, IEntryPoint} from "@thirdweb-dev/contracts/prebuilts/account/non-upgradeable/Account.sol";

error AccountWallet__InvalidChainId(uint256 chainId);
error AccountWallet__NotAdminForEntryPoint(address sender);

contract AccountWallet is Account {
    uint256 public s_chainId;
    address private s_tokenContract;
    uint256 private s_tokenId;

    // Modifiers
    modifier onlyOwnerOrEntrypoint() {
        if (msg.sender == address(entryPoint()) || owner() == msg.sender)
            revert AccountWallet__NotAdminForEntryPoint(msg.sender);
        _;
    }

    // Functions
    constructor(
        IEntryPoint entryPoint,
        address factory
    ) Account(entryPoint, factory) {
        _disableInitializers();
    }

    function isValidSigner(
        address _signer
    ) public view override returns (bool) {
        return (owner() == _signer);
    }

    function owner() public view returns (address) {
        if (s_chainId != block.chainid)
            revert AccountWallet__InvalidChainId(s_chainId);
        return IERC721(s_tokenContract).ownerOf(s_tokenId);
    }

    function getChainId() public view returns (uint256) {
        return s_chainId;
    }

    function getTokenContract() public view returns (address) {
        return s_tokenContract;
    }

    function getTokenId() public view returns (uint256) {
        return s_tokenId;
    }
}
