pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC777/IERC777.sol";
import "../FeeIncome.sol";

/**
 * @title ERC777FeeIncome
 */
contract ERC777FeeIncome is IERC777, FeeIncome {

  /**
   * @dev Collect outstanding fees.
   *
   * @dev See `FeeIncome.collectFees`.
   */
  function collectFees() external {
    uint256 amount = _computeAndClearFees(msg.sender);
    this.send(msg.sender, amount, "");
    emit FeeCollected(msg.sender, amount);
  }
  
  /**
   * @dev Charge a fee.
   *
   * @dev See `FeeIncome._chargeFee`.
   */
  function _chargeFee(address account, uint256 feeAmount) internal {
    _chargeFee(account, feeAmount, "", "");
  }
  
  /**
   * @dev Charge a fee.
   *
   * @dev See `FeeIncome._chargeFee`.
   */
  function _chargeFee(
    address account, 
    uint256 feeAmount,
    bytes memory data,
    bytes memory operatorData
  ) internal {
    require(
      this.isOperatorFor(address(this), account),
      "ERC777FeeIncome: contract not an authorized operator of the given account."
    );
    this.operatorSend(account, address(this), feeAmount, data, operatorData);
    super._chargeFee(account, feeAmount);
  }
}
