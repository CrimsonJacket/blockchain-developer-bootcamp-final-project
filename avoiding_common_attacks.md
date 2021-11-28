# Avoiding Common Attacks
The `RequestPayment` contract uses several mechanisms explained in the course to avoid common attacks.

## Proper use of Require, Assert and Revert
RequestPayment uses **require** mostly in the form of modifiers. It also makes direct use of the **require** function to stop the execution of  _`claimApprovedRequest()`_ if there are no unlocked payments to claim, and to validate the transactions done to send founds are successful. 

## Use modifiers only for validation
All `modifiers` included in the contract perform just validations.

## Pull over push
RequestPayment was implemented in a way where partipants can only claim payments after it has been appoved by the payer.

## Checks-Effects-Interactions
The only place where transfer of fund is enforces this rule. In _`claimApprovedRequest()`_ all states are updated before the transfer is made.