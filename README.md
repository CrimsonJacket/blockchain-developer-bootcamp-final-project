# Request Payments DApp

Request Payments on the blockchain. Final Project for the ConsenSys Academy 2021 Developer Bootcamp

## Tables of Contents
- [Request Payments DApp](#request-payments-dapp)
  - [Tables of Contents](#tables-of-contents)
  - [Project Idea](#project-idea)
  - [Use Cases](#use-cases)
  - [Directory Structure](#directory-structure)
  - [Installing Dependencies](#installing-dependencies)
  - [Deploying Locally](#deploying-locally)
  - [Running Test Cases](#running-test-cases)
  - [Accessing via Netlify](#accessing-via-netlify)
  - [Additional Ideas to explore](#additional-ideas-to-explore)

## Project Idea

The idea of this project is to create a contract that allows a participant(receiver) to request payment from another partipant(payer). All the requests and its status can be viewed all participants. This aims to encourage participants to clear their debts.

A payment request can be created by any user(receiver). A payment request would detail the amount requested and the intended payer.

Payer can choose accept the request, when he/she does so, the contract will determine if the payer has enough balance to fulfil the request. If so, the payment amount can be claimed.

## Use Cases

- A participant(Receiver) can create a request to another participant(Payer). The request would detail the payer's address as well the requested amount
- A user(Payer) can choose to approve the request.
  - Chooses to approve: Payer would be prompt to approve said transaction. In which case, he/she will submit a transfer value of the requested amount to the contract address. The request will be marked as `APPROVED`.
  - Chooses **NOT** to approve: Request remains in `OPEN`.
- A user(Receiver) can choose to cancel an `OPEN` request, between the time of request creation and approval by the assigned Payer.
- A user can view all the requests they have created.
- A user can view all the requests made to them.

## Directory Structure

```
$PROJECT_HOME
├── contracts/
│   ├── Migrations.sol
│   └── RequestPayments.sol
├── migrations/
│   ├── 1_initial_migration.js
│   └── 2_deployed_contracts.js
├── react-app/
│   └── ...
├── test/
│   └── RequestPayment.test.js
└── ...
```

- `contracts`: contains the Request contracts of the project.
- `migrations`: contains the deployment scripts(JS) for both `Migrations.sol` and `RequestPayment.sol`.
- react-app: contains the files for the React front-end.
- test: contains all the tests for `RequestPayments.sol` contract.

## Installing Dependencies

## Deploying Locally

## Running Test Cases

## Accessing via Netlify

## Additional Ideas to explore
- Make it possible for Payer to approve a partial payment.
- Explore ways for Payer to reject a payment.
