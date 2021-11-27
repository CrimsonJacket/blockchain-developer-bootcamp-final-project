# Request Payments DApp

Request Payments on the blockchain. Final Project for the ConsenSys Academy 2021 Developer Bootcamp

A payment request can be created by any user(receiver). A payment request would detail the amount requested and the intended payer.

Payer can choose accept the request, when he/she does so, the contract will determine if the payer has enough balance to fulfil the request. If so, the payment amount can be claimed.

## Request

A Request is defined with the following attributes/members:
- id: `int`
- amount: `uint`
- receiver: `address`
- payer: `address`
- state: `RequestState`

