const RequestPayment = artifacts.require("./RequestPayment.sol");

const {
    BN,           // Big Number support
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
    snapshot,
  } = require('@openzeppelin/test-helpers');

contract("RequestPayment", accounts => {
    const [owner, payer1, payer2, receiver1, receiver2] = accounts;
    var instance;

    beforeEach(async() => {
        timeSnapshot = await snapshot();
        instance = await RequestPayment.new({from: owner});
        await instance.initialize({from: owner});
    });
 
    afterEach(async() => {
        await timeSnapshot.restore();
    });

    it("Receiver can create a payment request", async () => {
        var payer = payer1;
        var paymentAmount = 5000;
        var txReceipt = await instance.createRequest(payer, paymentAmount, {from: receiver1});

        expectEvent(txReceipt, 'LogRequestCreated', { payer: payer1, receiver: receiver1, amount: new BN(5000), requestId: new BN(0)});
    });

    it("Receiver can cancel a payment request", async () => {
        var payer = payer1;
        var paymentAmount = 5000;
        var txReceiptCreateRequest = await instance.createRequest(payer, paymentAmount, {from: receiver1});

        expectEvent(txReceiptCreateRequest, 'LogRequestCreated', { payer: payer1, receiver: receiver1, amount: new BN(5000), requestId: new BN(0)});

        var txReceiptCancelRequest = await instance.cancelRequest(0 , {from: receiver1})
        
        expectEvent(txReceiptCancelRequest, 'LogRequestCancelled', { receiver: receiver1, requestId: new BN(0)});
    });

});