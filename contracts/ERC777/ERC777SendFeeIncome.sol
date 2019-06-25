pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC777FeeIncome.sol";

/**
 * @title ERC777SendFeeIncome
 */
contract ERC777SendFeeIncome is ERC777FeeIncome {
  using SafeMath for uint256;

  uint256 private _sendFeeInverse;

  constructor(uint256 sendFeeInverse) public {
    require(sendFeeInverse > 0, "ERC777SendFeeIncome: sendFeeInverse is 0");
    _sendFeeInverse = sendFeeInverse;
  }

  function send(address to, uint256 amount, bytes calldata data) external {
    super.send(to, amount, data);
    super.send(address(this), _sendFee(amount), "");
    _feeCharged(msg.sender, _sendFee(amount));
  }
  
  function operatorSend(
    address from, 
    address to, 
    uint256 amount,
    bytes calldata data,
    bytes calldata operatorData
  ) external {
    super.operatorSend(from, to, amount, data, operatorData);
    super.operatorSend(from, address(this), _sendFee(amount), "", "");
    _feeCharged(sender, _sendFee(amount));
  }

  function sendFeeInverse() public view returns (uint256) {
    return _sendFeeInverse;
  }

  function _sendFee(uint256 amount) internal view returns (uint256) {
    return amount.div(_sendFeeInverse);
  }
}
