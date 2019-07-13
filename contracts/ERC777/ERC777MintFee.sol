pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC777FeeIncome.sol";

/**
 * @title ERC777MintFee
 */
contract ERC777MintFee is ERC777FeeIncome {
  using SafeMath for uint256;

  uint256 private _mintFeeInverse;

  constructor(uint256 mintFeeInverse) public {
    require(mintFeeInverse > 0, "ERC777MintFeeIncome: mintFeeInverse is 0");
    _mintFeeInverse = mintFeeInverse;
  }

  /**
   * @dev Charges `account` a mint-fee relative to `mintAmount`.
   *
   * @dev Usage example:
   * ```
   * function mint(address account, uint256 amount) public {
   *   super.mint(account, amount);
   *   _chargeMintFee(msg.sender, amount);
   * }
   * ```
   * 
   * @param account The account to charge.
   * @param mintAmount The amount to be minted.
   */
  function _chargeMintFee(address account, uint256 mintAmount) internal {
    _chargeFee(account, _mintFee(mintAmount));
  }

  function mintFeeInverse() public view returns (uint256) {
    return _mintFeeInverse;
  }

  function _mintFee(uint256 amount) internal view returns (uint256) {
    return amount.div(_mintFeeInverse);
  }
}
