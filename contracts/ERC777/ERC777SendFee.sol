pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC777FeeIncome.sol";

/**
 * @title ERC777SendFee
 */
contract ERC777SendFee is ERC777FeeIncome {
  using SafeMath for uint256;

  uint256 private _sendFeeInverse;

  constructor(uint256 sendFeeInverse) public {
    require(sendFeeInverse > 0, "ERC777SendFeeIncome: sendFeeInverse is 0");
    _sendFeeInverse = sendFeeInverse;

  }

  /**
   * @dev Returns the inverse of the send-fee.
   */
  function sendFeeInverse() public view returns (uint256) {
    return _sendFeeInverse;
  }

  /**
   * @dev Charges `account` a send-fee relative to `sendAmount`.
   *
   * @dev Usage example:
   * ```
   * function send(address recipient, uint256 amount, bytes calldata data) public {
   *   super.send(recipient, amount, data);
   *   _chargeSendFee(msg.sender, amount);
   * }
   *
   * function operatorSend(
   *   address sender,
   *   address recipient,
   *   uint256 amount,
   *   bytes calldata data,
   *   bytes calldata operatorData
   * ) public {
   *   super.operatorSend(sender, recipient, amount, data, operatorData);
   *   _chargeSendFee(sender, amount);
   * }
   * ```
   * 
   * @param account The account to charge.
   * @param sendAmount The amount to be sent.
   */
  function _chargeSendFee(address account, uint256 sendAmount) internal {
    _chargeFee(account, _sendFee(sendAmount));
  }

  function _sendFee(uint256 amount) private view returns (uint256) {
    return amount.div(_sendFeeInverse);
  }
}
