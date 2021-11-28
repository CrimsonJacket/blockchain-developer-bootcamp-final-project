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
        CLAIMED
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
    mapping(address => uint256[]) public payerPayments;

    // Events

    event LogRequestCreated(address payer, address receiver, uint amount, uint256 requestId);
    event LogRequestCancelled(address receiver, uint256 requestId);
    event LogRequestApproved(address payer, address receiver, uint amount);
    event LogRequestClaimed(address payer, address receiver, uint amount);

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

    function getMyRequests() public view returns(Request[] memory) {
        uint[] storage myRequestIds = receiverRequests[msg.sender];
        Request[] memory myRequests = new Request[](myRequestIds.length);
        for (uint i = 0; i < myRequestIds.length; i++) {
            myRequests[i] = requests[myRequestIds[i]];
        }
        return myRequests;
    }

    function createRequest(address payerAddr, uint amount)
        public
        checkReceiverNotPayer(payerAddr)
        checkValidRequest(amount)
        returns (uint256)
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
        payerPayments[payerAddr].push(newRequest.id);

        counter = counter + 1;
        emit LogRequestCreated(payerAddr, msg.sender, amount, counter);

        return newRequest.id;
    }

    function cancelRequest(uint256 requestId)
        public
        checkRequestOwner(requestId)
    {
        Request memory request = requests[requestId];
        request.state = RequestState.CANCELLED;
        requests[requestId] = request;
        emit LogRequestCancelled(msg.sender, requestId);
    }

    function approveRequest(uint256 requestId)
        public
        payable
        checkRequestPayer(requestId)
    {
        uint amountPaid = msg.value;
        Request memory request = requests[requestId];
        require(request.amount == amountPaid);
        request.state = RequestState.APPROVED;
        requests[requestId] = request;
        emit LogRequestApproved(msg.sender, request.receiver, request.amount);
    }

    function claimApprovedRequest()
        public
    {
        uint[] storage myRequestIds = receiverRequests[msg.sender];
        uint amountToClaim;

        for (uint i = 0; i < myRequestIds.length; i++) {
            Request memory request = requests[myRequestIds[i]];
            if (request.state == RequestState.APPROVED) {
                amountToClaim = request.amount + amountToClaim;
                request.state = RequestState.CLAIMED;
                requests[myRequestIds[i]] = request;
                emit LogRequestClaimed(request.payer, request.receiver, request.amount);
            }
        }

        require(amountToClaim > 0, "You do not have any approved requests to claim.");
        (bool sent, ) = msg.sender.call{value: amountToClaim}("");
        require(sent, "Failed to send Ether");
    }
    
}
