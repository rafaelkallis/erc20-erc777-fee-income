pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC20FeeIncome.sol";

/**
 * @title ERC20TransferFee
 */
contract ERC20TransferFee is ERC20FeeIncome {
  using SafeMath for uint256;

  uint256 private _transferFeeInverse;

  constructor(uint256 transferFeeInverse) public {
    require(transferFeeInverse > 0, "ERC20TransferFee: transferFeeInverse is 0");
    _transferFeeInverse = transferFeeInverse;
  }

  /**
   * @dev Charges `account` a transfer-fee relative to `transferAmount`.
   *
   * @dev Usage example:
   * ```
   * function transfer(address to, uint256 amount) public returns (bool) {
   *   require(super.transfer(to, amount));
   *   _chargeTransferFee(msg.sender, amount);
   *   return true;
   * }
   *
   * function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
   *   require(super.transferFrom(sender, recipient, amount));
   *   _chargeTransferFee(sender, amount);
   *   return true;
   * }
   * ```
   * 
   * @param account The account to charge.
   * @param transferAmount The amount to be transferred.
   */
  function _chargeTransferFee(address account, uint256 transferAmount) internal {
    _chargeFee(account, _transferFee(transferAmount));
  }

  function transferFeeInverse() public view returns (uint256) {
    return _transferFeeInverse;
  }

  function _transferFee(uint256 amount) private view returns (uint256) {
    return amount.div(_transferFeeInverse);
  }
}
