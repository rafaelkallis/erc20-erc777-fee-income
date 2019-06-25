pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @title FeeIncome
 */
contract FeeIncome {
  using SafeMath for uint256;

  mapping (uint256 => uint256[]) internal _blockFees;
  uint256 internal _outstandingFees;

  /**
   * @dev Collect any outstanding fees the message sender is
   * entitled to receive. Calling this method will result in 
   * a balance increase of the message sender.
   */
  function collectFees() external;

  /**
   * @dev Returns an array containing fee amounts that have
   * been charged during the block with the given blocknumber.
   */
  function blockFees(uint256 blocknumber) public view returns (uint256[] memory) {
    return _blockFees[blocknumber];
  }

  /**
   * @dev Returns the total amount of outstanding fees.
   */
  function outstandingFees() public view returns (uint256) {
    return _outstandingFees;
  }
  
  /**
   * @dev Computes the amount of outstanding fees the message 
   * sender is entitled to receive. The (internal) function
   * caller is responsible for transfering the amount of 
   * outstanding fees to the message sender. After calling this
   * method, the message sender's outstanding fees are cleared.
   */
  function _computeAndClearFees() internal returns (uint256);
  
  /**
   * @dev This method MUST be called when a charge occurs.
   */
  function _feeCharged(address account, uint256 amount) internal {
    _outstandingFees = _outstandingFees.add(amount);
    _blockFees[block.number].push(amount);
    emit FeeCharged(account, amount);
  }
  
  /**
   * @dev Emitted when an account has collected its respective
   * outstanding fees.
   */
  event FeeCollected(address indexed account, uint256 amount);

  /**
   * @dev Emitted when a charge occurs.
   */
  event FeeCharged(address indexed account, uint256 amount);
}
