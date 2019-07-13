pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC777/IERC777.sol";
import "../ShareholderFeeIncomeShare.sol";

/**
 * @title ERC777ShareholderFeeIncomeShare
 */
contract ERC777ShareholderFeeIncomeShare is IERC777, ShareholderFeeIncomeShare {

  function _beforeSend(address sender, address recipient) internal {
    _updateBalance(sender, this.balanceOf(sender));
    _updateBalance(recipient, this.balanceOf(recipient));
  }
  
  function _beforeMint(address account) internal {
    _updateBalance(account, this.balanceOf(account));
    _updateTotalSupply(this.totalSupply());
  }
  
  function _beforeBurn(address account) internal {
    _updateBalance(account, this.balanceOf(account));
    _updateTotalSupply(this.totalSupply());
  }
}
