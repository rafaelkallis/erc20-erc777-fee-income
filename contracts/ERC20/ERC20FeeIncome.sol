pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "../FeeIncome.sol";

/**
 * @title ERC20FeeIncome
 * @author Rafael Kallis <rk@rafaelkallis.com>
 */
contract ERC20FeeIncome is IERC20, FeeIncome {

  /**
   * @dev Collect outstanding fees.
   *
   * @dev See `FeeIncome.collectFees`.
   */
  function collectFees() external {
    uint256 amount = _computeAndClearFees(msg.sender);
    this.transfer(msg.sender, amount);
    emit FeeCollected(msg.sender, amount);
  }

  /**
   * @dev Charge a fee.
   *
   * @dev See `FeeIncome._chargeFee`.
   */
  function _chargeFee(address account, uint256 feeAmount) internal {
    require(
      this.allowance(account, address(this)) >= feeAmount,
      "ERC20FeeIncome: insufficient allowance to charge fee."
    );
    require(
      this.transferFrom(account, address(this), feeAmount),
      "ERC20FeeIncome: charge failed."
    );
    super._chargeFee(account, feeAmount);
  }
}
