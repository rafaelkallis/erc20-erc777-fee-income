pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "../ShareholderFeeIncomeShare.sol";

/**
 * @title ERC20ShareholderFeeIncomeShare
 */
contract ERC20ShareholderFeeIncomeShare is IERC20, ShareholderFeeIncomeShare {

  // function transfer(address to, uint256 amount) public returns (bool) {
  //   _beforeTransferHook(msg.sender, to);
  //   require(
  //     super.transfer(to, amount),
  //     "ERC20ShareholderFeeIncomeShare: super tranfer failed."
  //   );
  //   return true;
  // }

  // function transferFrom(address from, address to, uint256 amount) public returns (bool) {
  //   _beforeTransferHook(from, to);
  //   require(
  //     super.transferFrom(from, to, amount),
  //     "ERC20ShareholderFeeIncomeShare: super tranferFrom failed."
  //   );
  //   return true;
  // }

  function _beforeTransfer(address sender, address recipient) internal {
    _updateBalance(sender, this.balanceOf(sender));
    _updateBalance(recipient, this.balanceOf(recipient));
  }
}
