pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/IERC20/IERC20.sol";
import "../ShareholderFeeIncomeShare.sol";

/**
 * @title ERC20ShareholderFeeIncomeShare
 */
contract ERC20ShareholderFeeIncomeShare is ShareholderFeeIncomeShare, IERC20 {

  struct TemporalValue {
    uint256 fromBlock;
    uint256 toBlock;
    uint256 value;
  }

  mapping(address => TemporalValue[]) private _balances;
  TemporalValue[] private _totalSupplies;

  function transfer(address recipient, uint256 amount) public returns (bool) {
    uint256 previousSenderBalance = balanceOf(msg.sender);
    uint256 previousRecipientBalance = balanceOf(recipient);
    if (!super.transfer(recipient, amount)) {
      return false;
    }
    _updateBalance(msg.sender, previousSenderBalance);
    _updateBalance(recipient, previousRecipientBalance);
    return true;
  }

  function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
    uint256 previousSenderBalance = balanceOf(sender);
    uint256 previousRecipientBalance = balanceOf(recipient);
    if (!super.transferFrom(sender, recipient, amount)) {
      return false;
    }
    _updateBalance(sender, previousSenderBalance);
    _updateBalance(recipient, previousRecipientBalance);
    return true;
  }
}
