pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC20FeeIncome.sol";

/**
 * @title ERC20TransferFee
 * @author Rafael Kallis <rk@rafaelkallis.com>
 */
contract ERC20TransferFee is ERC20FeeIncome {
  using SafeMath for uint256;

  uint256 private _transferFee;

  constructor(uint256 transferFee) public {
    _transferFee = transferFee;
  }

  /**
   * @dev Returns the transfer fee.
   */
  function transferFee() public view returns (uint256) {
    return _transferFee;
  }

  /**
   * @dev Returns the transfer fee relative to `transferAmount`.
   */
  function transferFee(uint256 transferAmount) public view returns (uint256) {
    return transferAmount.mul(_transferFee).div(10 ** 18);
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
    _chargeFee(account, transferFee(transferAmount));
  }
}
