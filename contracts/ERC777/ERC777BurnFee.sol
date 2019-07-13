pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC777FeeIncome.sol";

/**
 * @title ERC777BurnFee
 * @author Rafael Kallis <rk@rafaelkallis.com>
 */
contract ERC777BurnFee is ERC777FeeIncome {
  using SafeMath for uint256;

  uint256 private _burnFeeInverse;

  constructor(uint256 burnFeeInverse) public {
    require(burnFeeInverse > 0, "ERC777BurnFeeIncome: burnFeeInverse is 0");
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
   * function burn(uint256 amount, bytes calldata data) public {
   *   super.burn(amount, data);
   *   _chargeBurnFee(msg.sender, amount);
   * }
   * 
   * function operatorBurn(
   *   address from, 
   *   uint256 amount,
   *   bytes memory data,
   *   bytes memory operatorData
   * ) public {
   *   super.operatorBurn(from, amount, data, operatorData);
   *   _chargeBurnFee(from, amount);
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
