pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC20FeeIncome.sol";

/**
 * @title ERC20BurnFee
 * @author Rafael Kallis <rk@rafaelkallis.com>
 */
contract ERC20BurnFee is ERC20FeeIncome {
  using SafeMath for uint256;

  uint256 private _burnFeeInverse;

  constructor(uint256 burnFeeInverse) public {
    require(burnFeeInverse > 0, "ERC20BurnFee: burnFeeInverse is 0");
    _burnFeeInverse = burnFeeInverse;
  }

  /**
   * @dev Returns the inverse of the burn-fee.
   */
  function burnFeeInverse() public view returns (uint256) {
    return _burnFeeInverse;
  }

  /**
   * @dev Charges `account` a burn-fee relative to `burnAmount`.
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
    _chargeFee(account, _burnFee(burnAmount));
  }

  function _burnFee(uint256 amount) private view returns (uint256) {
    return amount.div(_burnFeeInverse);
  }
}
