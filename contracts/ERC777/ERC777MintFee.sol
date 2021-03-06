pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC777FeeIncome.sol";

/**
 * @title ERC777MintFee
 * @author Rafael Kallis <rk@rafaelkallis.com>
 */
contract ERC777MintFee is ERC777FeeIncome {
  using SafeMath for uint256;

  uint256 private _mintFee;

  constructor(uint256 mintFee) public {
    _mintFee = mintFee;
  }

  /**
   * @dev Returns the mint fee.
   */
  function mintFee() public view returns (uint256) {
    return _mintFee;
  }

  /**
   * @dev Returns the mint fee relative to `mintAmount`.
   */
  function mintFee(uint256 mintAmount) public view returns (uint256) {
    return mintAmount.mul(_mintFee).div(10 ** 18);
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
    _chargeFee(account, mintFee(mintAmount));
  }
}
