// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
pragma experimental ABIEncoderV2;

/// @title A contract to register request payments and to claim them if they are accepted.
/// @author Daniel Tan
/// @notice Not extensively tested. Use at your own risk.
contract RequestPayment {

    enum RequestState {
        OPEN,
        APPROVED,
        CANCELLED,
        FILLED
    }

    struct Request {
        uint256 id;
        address payer;
        address receiver;
        uint amount;
        RequestState state;
    }

    uint256 public counter;
    Request[] public requests;
    mapping(uint256 => address) public requestIdToReceiverAddr;
    mapping(uint256 => address) public requestIdToPayerAddr;
    mapping(address => uint256[]) public receiverRequests;
    mapping(address => uint256[]) public payerRequests;

    // Events

    event LogRequestCreated(address payer, address receiver, uint amount, uint256 requestId);
    event LogRequestCancelled(address receiver, uint256 requestId);
    event LogRequestApproved(address payer, address receiver, uint amount);

    /*
     * Modifiers
     */
    modifier checkReceiverNotPayer(address _receiver) {
        require(
            msg.sender != _receiver,
            "The payer address cannot be the receiver address"
        );
        _;
    }

    modifier checkValidRequest(uint _amount) {
        require(_amount > 0, "Invalid amount");
        _;
    }

    modifier checkRequestOwner(uint _requestId) {
        Request memory request = requests[_requestId];
        require(request.receiver == msg.sender, "You're not the owner of this request.");
        _;
    }

    modifier checkRequestPayer(uint256 _requestId) {
        require(
            requestIdToPayerAddr[_requestId] == msg.sender,
            "No matching request found."
        );
        _;
    }

    function getAllRequests() public view returns(Request[] memory) {
        return requests;
    }

    function createRequest(address payerAddr, uint amount)
        public
        payable
        checkReceiverNotPayer(payerAddr)
        checkValidRequest(amount)
    {

        Request memory newRequest = Request(
            counter,
            payerAddr,
            msg.sender,
            amount,
            RequestState.OPEN
        );
        requests.push(newRequest);

        requestIdToReceiverAddr[newRequest.id] = msg.sender;
        requestIdToPayerAddr[newRequest.id] = payerAddr;
        receiverRequests[msg.sender].push(newRequest.id);
        payerRequests[payerAddr].push(newRequest.id);

        counter = counter + 1;
        emit LogRequestCreated(payerAddr, msg.sender, amount, counter);
    }

    function cancelRequest(uint256 requestId)
        public
        checkRequestOwner(requestId)
    {
        Request memory request = requests[requestId];
        request.state = RequestState.CANCELLED;
        emit LogRequestCancelled(msg.sender, requestId);
    }

    function approveRequest(uint256 requestId)
        public
        payable
        checkRequestPayer(requestId)
    {
        Request storage request = requests[requestId];
        emit LogRequestApproved(msg.sender, request.receiver, request.amount);

        (bool sent, ) = msg.sender.call{value: request.amount}("");
        require(sent, "Failed to send Ether");
        if (sent) {
            request.state = RequestState.FILLED;
        }
    }
}
