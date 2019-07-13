pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC20FeeIncome.sol";

/**
 * @title ERC20MintFee
 */
contract ERC20MintFee is ERC20FeeIncome {
  using SafeMath for uint256;

  uint256 private _mintFeeInverse;

  constructor(uint256 mintFeeInverse) public {
    require(mintFeeInverse > 0, "ERC20MintFee: mintFeeInverse is 0");
    _mintFeeInverse = mintFeeInverse;
  }


  function mintFeeInverse() public view returns (uint256) {
    return _mintFeeInverse;
  }

  /**
   * @dev Charges `account` a mint-fee relative to `mintAmount`.
   *
   * @dev Usage example:
   * ```
   * function mint(address account, uint256 amount) public returns (bool) {
   *   require(super.mint(account, amount));
   *   _chargeMintFee(msg.sender, amount);
   *   return true;
   * }
   * ```
   * 
   * @param account The account to charge.
   * @param mintAmount The amount to be minted.
   */
  function _chargeMintFee(address account, uint256 mintAmount) internal {
    _chargeFee(account, _mintFee(mintAmount));
  }

  function _mintFee(uint256 amount) private view returns (uint256) {
    return amount.div(_mintFeeInverse);
  }
}
