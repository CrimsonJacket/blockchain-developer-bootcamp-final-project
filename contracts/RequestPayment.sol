// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/access/Ownable.sol";

struct Request {
    uint id;
    address payer;
    address receiver;
    uint amount;
}

/// @title A contract to register request payments and to claim them if they are accepted.
/// @author Daniel Tan
/// @notice Not extensively tested. Use at your own risk.
contract RequestPayment {

    mapping(uint => Request) public requests;

}