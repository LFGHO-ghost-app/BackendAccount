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

import {Account, IEntryPoint} from "@thirdweb-dev/contracts/prebuilts/account/non-upgradeable/Account.sol";

error AccountWallet__InvalidChainId(uint256 chainId);
error AccountWallet__NotAdminForEntryPoint(address sender);
error AccountWallet__NotTokenOnwer(address owner);
error AccountWallet__WrongArrayLength();
error AccountWallet__NotNftOwner(address sender);

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}
contract AccountWallet is Account {
    address marketplaceAddress = 0x02E2e0791Ac89F219aCA15FE109F5cD7f83C9a07;
    IERC20 public ghoToken = IERC20(0xc4bF5CbDaBE595361438F8c6a187bDc330539c60);

    /*///////////////////////////////////////////////////////////////
                                State
    //////////////////////////////////////////////////////////////*/

    uint256 public s_chainId;

    /*///////////////////////////////////////////////////////////////
                            Modifiers
    //////////////////////////////////////////////////////////////*/

    /*///////////////////////////////////////////////////////////////
                            Constructor
    //////////////////////////////////////////////////////////////*/

    constructor(IEntryPoint entryPoint, address factory) Account(entryPoint, factory) {
        _disableInitializers();
    }

    /*///////////////////////////////////////////////////////////////
                        External functions
    //////////////////////////////////////////////////////////////*/
    function getMessageHash(uint _amount) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_amount));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }
    function acceptPayment(address _signer, uint _amount, bytes memory signature) public returns (bool) {
        uint256 amount = _amount * 10 ** 18;
        bool success = ghoToken.transfer(marketplaceAddress, amount);
        require(success, "Transfer failed");
        return true;
    }

    function acceptPaymentTwo(address _signer, uint256 _amount, bytes memory signature) public returns (bool) {
        uint256 amount = _amount * 10 ** 18;
        address userAddress = getSignatureAddress(_signer, _amount, signature);
        bool success = ghoToken.transfer(marketplaceAddress, amount);
        require(success, "Transfer failed");
    }

    function getSignatureAddress(address _signer, uint _amount, bytes memory signature) public pure returns (address) {
        bytes32 messageHash = getMessageHash(_amount);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        address _recoverSigner = recoverSigner(ethSignedMessageHash, signature);
        require(_recoverSigner == _signer, "The signer is not valid ");
        return _recoverSigner;
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig) public pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(sig.length == 65, "invalid signature length");

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

    /*///////////////////////////////////////////////////////////////
                            View functions
    //////////////////////////////////////////////////////////////*/
    function senderBalance() public view returns (uint) {
        return ghoToken.balanceOf(msg.sender);
    }

    function ghoBalance() public view returns (uint) {
        return ghoToken.balanceOf(address(this));
    }

    function getChainId() public view returns (uint256) {
        return s_chainId;
    }

    /*///////////////////////////////////////////////////////////////
                            Internal functions
    //////////////////////////////////////////////////////////////*/
}
