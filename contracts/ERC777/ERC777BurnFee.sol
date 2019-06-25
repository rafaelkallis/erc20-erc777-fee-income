pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC777FeeIncome.sol";

/**
 * @title ERC777BurnFee
 */
contract ERC777BurnFee is ERC777FeeIncome {
  using SafeMath for uint256;

  uint256 private _burnFeeInverse;

  constructor(uint256 burnFeeInverse) public {
    require(burnFeeInverse > 0, "ERC777BurnFeeIncome: burnFeeInverse is 0");
    _burnFeeInverse = burnFeeInverse;
  }

  function burn(uint256 amount, bytes calldata data) external {
    super.burn(amount, data);
    super.send(address(this), _burnFee(amount), "");
    _feeCharged(msg.sender, _burnFee(amount));
  }
  
  function operatorBurn(
    address from, 
    uint256 amount,
    bytes calldata data,
    bytes calldata operatorData
  ) external {
    super.operatorBurn(from, amount, data, operatorData);
    super.operatorSend(from, address(this), _burnFee(amount), "", "");
    _feeCharged(sender, _burnFee(amount));
  }

  function burnFeeInverse() public view returns (uint256) {
    return _burnFeeInverse;
  }

  function _burnFee(uint256 amount) internal view returns (uint256) {
    return amount.div(_burnFeeInverse);
  }
}
