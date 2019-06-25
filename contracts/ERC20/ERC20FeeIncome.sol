pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "../FeeIncome.sol";

/**
 * @title ERC20FeeIncome
 */
contract ERC20FeeIncome is FeeIncome, IERC20 {

  function collectFees() external {
    uint256 amount = _computeAndClearFees();
    this.transfer(msg.sender, amount);
    emit FeeCollected(msg.sender, amount);
  }
}
