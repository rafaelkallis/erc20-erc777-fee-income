pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./FeeIncome.sol";

/**
 * @title SingleOwnerFeeIncome
 */
contract SingleOwnerFeeIncome is FeeIncome, Ownable {

  function _computeAndClearFees() internal onlyOwner returns (uint256) {
    uint256 amount = _outstandingFees;
    _outstandingFees = 0;
    return amount;
  }
}
