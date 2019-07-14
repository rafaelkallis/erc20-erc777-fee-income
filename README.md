# ERC20FeeIncome, ERC777FeeIncome

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

The implementation relies on the `ERC20` approval, and `ERC777` operator mechanism.

## Usage Guide

### 1. Add transfer fee to `ERC20` token:
```js
contract MyToken is ERC20, ERC20TransferFee(0.05 * 10e18) { // 5% transfer fee

  function transfer(address to, uint256 amount) public returns (bool) {
    require(super.transfer(to, amount));
    _chargeTransferFee(msg.sender, amount);
    return true;
  }
  
  function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
    require(super.transferFrom(sender, recipient, amount));
    _chargeTransferFee(sender, amount);
    return true;
  }
}
```

### 2. Add mint fee to `ERC20` token:
```js
contract MyToken is ERC20, ERC20Mintable, ERC20MintFee(0.001 * 10e18) { // 0.1% mint fee

  function mint(address account, uint256 amount) public returns (bool) {
    require(super.mint(account, amount));
    _chargeMintFee(msg.sender, amount);
    return true;
  }
}
```

### 3. Add burn fee to `ERC20` token:
```js
contract MyToken is ERC20, ERC20Burnable, ERC20BurnFee(0.01 * 10e18) { // 1% burn fee

  function burn(uint256 amount) public {
    super.burn(amount);
    _chargeBurnFee(msg.sender, amount);
  }
  
  function burnFrom(address account, uint256 amount) public {
    super.burnFrom(account, amount);
    _chargeBurnFee(account, amount);
  }
}
```

### 4. Add send fee to `ERC777` token:
```js
contract MyToken is ERC777, ERC777SendFee(0.005) { // 0.5% send fee

  function send(address recipient, uint256 amount, bytes calldata data) public {
    super.send(recipient, amount, data);
    _chargeSendFee(msg.sender, amount);
  }
  
  function operatorSend(
    address sender,
    address recipient,
    uint256 amount,
    bytes calldata data,
    bytes calldata operatorData
  ) public {
    super.operatorSend(sender, recipient, amount, data, operatorData);
    _chargeSendFee(sender, amount);
  }
}
```
