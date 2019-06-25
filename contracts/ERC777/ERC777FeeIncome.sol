pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC777/IERC777.sol";
import "../FeeIncome.sol";

/**
 * @title ERC777FeeIncome
 */
contract ERC777FeeIncome is FeeIncome, IERC777 {

  function collectFees() external {
    uint256 amount = computeAndClearFees();
    this.send(msg.sender, amount, "");
    emit FeeCollected(msg.sender, amount);
  }
}
