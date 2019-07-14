## ERC20FeeIncome, ERC777FeeIncome

#### A reusable token standard for creating tokenized, fee-based, revenue streams.

Goal of this project is to allow `ERC20` and `ERC777` token to support 
fee charging and fee redistibution either to a single owner or
a set of shareholders.

> :warning: **This code has not been reviewed or audited.** :warning:

The project provides support for the following stories:
- charge fee on token transfer events (`transfer`, `transferFrom`, `send`, `operatorSend`);
- charge fee on token mint events (`mint`);
- charge fee on token burn events (`burn`, `burnFrom`, `operatorBurn`);
- custom fee charge logic
- payout collected fees to single owner;
- payout collected fees to shareholders, where shares are in form of a `ERC20` or `ERC777` token. Feature supports dynamic shareholder balances and a dynamic circulating supply.
