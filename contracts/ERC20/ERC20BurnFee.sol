pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC20FeeIncome.sol";

/**
 * @title ERC20BurnFee
 * @author Rafael Kallis <rk@rafaelkallis.com>
 */
contract ERC20BurnFee is ERC20FeeIncome {
  using SafeMath for uint256;

  uint256 private _burnFee;

  constructor(uint256 burnFee) public {
    _burnFee = burnFee;
  }

  /**
   * @dev Returns the burn fee.
   */
  function burnFee() public view returns (uint256) {
    return _burnFee;
  }

  /**
   * @dev Returns the burn fee relative to `burnAmount`.
   */
  function burnFee(uint256 burnAmount) public view returns (uint256) {
    return burnAmount.mul(_burnFee).div(10 ** 18);
  }

  /**
   * @dev Charges `account` a burn fee relative to `burnAmount`.
   *
   * @dev Usage example:
   * ```
   * function burn(uint256 amount) public {
   *   super.burn(amount);
   *   _chargeBurnFee(msg.sender, amount);
   * }
   *
   * function burnFrom(address account, uint256 amount) public {
   *   super.burnFrom(account, amount);
   *   _chargeBurnFee(account, amount);
   * }
   * ```
   * 
   * @param account The account to charge.
   * @param burnAmount The amount to be burned.
   */
  function _chargeBurnFee(address account, uint256 burnAmount) internal {
    _chargeFee(account, burnFee(burnAmount));
  }
}
