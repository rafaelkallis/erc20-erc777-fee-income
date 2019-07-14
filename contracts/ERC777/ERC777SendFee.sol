pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC777FeeIncome.sol";

/**
 * @title ERC777SendFee
 * @author Rafael Kallis <rk@rafaelkallis.com>
 */
contract ERC777SendFee is ERC777FeeIncome {
  using SafeMath for uint256;

  uint256 private _sendFee;

  constructor(uint256 sendFee) public {
    _sendFee = sendFee;
  }

  /**
   * @dev Returns the send fee.
   */
  function sendFee() public view returns (uint256) {
    return _sendFee;
  }

  /**
   * @dev Returns the send fee relative to `sendAmount`.
   */
  function sendFee(uint256 sendAmount) public view returns (uint256) {
    return sendAmount.mul(_sendFee).div(10 ** 18);
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
    _chargeFee(account, sendFee(sendAmount));
  }
}
