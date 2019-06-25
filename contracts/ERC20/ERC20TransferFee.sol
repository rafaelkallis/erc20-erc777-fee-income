pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC20FeeIncome.sol";

/**
 * @title ERC20TransferFee
 */
contract ERC20TransferFee is ERC20FeeIncome {
  using SafeMath for uint256;

  uint256 private _transferFeeInverse;

  constructor(uint256 transferFeeInverse) public {
    require(transferFeeInverse > 0, "ERC20TransferFee: transferFeeInverse is 0");
    _transferFeeInverse = transferFeeInverse;
  }

  /**
   * @see IERC20#transfer()
   *
   * @dev Fee charge during transfer. The recipient is given the
   * full amount specified. Additionaly, the sender is charged a fee.
   */
  function transfer(address to, uint256 amount) public returns (bool) {
    if (!super.transfer(to, amount)) {
      return false;
    }
    require(
      super.transfer(address(this), _transferFee(amount)),
      "ERC20TransferFeeIncome: unsuccessful charge."
    );
    _feeCharged(msg.sender, _transferFee(amount));
    return true; 
  }
  
  /**
   * @see IERC20#transferFrom()
   *
   * @dev Fee charge during transfer. The recipient is given the
   * full amount specified. Additionaly, the sender is charged a fee.
   */
  function transferFrom(address from, address to, uint256 amount) public returns (bool) {
    if (!super.transferFrom(from, to, amount)) {
      return false;
    }
    require(
      super.transferFrom(from, address(this), _transferFee(amount)),
      "ERC20TransferFeeIncome: unsuccessful charge"
    );
    _feeCharged(from, _transferFee(amoun));
    return true; 
  }

  function transferFeeInverse() public view returns (uint256) {
    return _transferFeeInverse;
  }

  function _transferFee(uint256 amount) internal view returns (uint256) {
    return amount.div(_transferFeeInverse);
  }
}
