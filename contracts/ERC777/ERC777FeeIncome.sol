pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC777/IERC777.sol";
import "openzeppelin-solidity/contracts/token/ERC777/IERC777Recipient.sol";
import "openzeppelin-solidity/contracts/introspection/IERC1820Registry.sol";
import "../FeeIncome.sol";

/**
 * @title ERC777FeeIncome
 * @author Rafael Kallis <rk@rafaelkallis.com>
 */
contract ERC777FeeIncome is IERC777, IERC777Recipient, FeeIncome {

  IERC1820Registry constant private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

  constructor() public {
    _erc1820.setInterfaceImplementer(
      address(this),
      keccak256("ERC777TokensRecipient"),
      address(this)
    );
  }

  /**
   * @dev Collect outstanding fees.
   *
   * @dev See `FeeIncome.collectFees`.
   */
  function collectFees() external {
    uint256 amount = _computeAndClearFees(msg.sender);
    this.send(msg.sender, amount, "");
    emit FeeCollected(msg.sender, amount);
  }
  
  /**
   * @dev Charge a fee.
   *
   * @dev See `FeeIncome._chargeFee`.
   */
  function _chargeFee(address account, uint256 feeAmount) internal {
    _chargeFee(account, feeAmount, "", "");
  }
  
  /**
   * @dev Charge a fee.
   *
   * @dev See `FeeIncome._chargeFee`.
   */
  function _chargeFee(
    address account, 
    uint256 feeAmount,
    bytes memory data,
    bytes memory operatorData
  ) internal {
    require(
      this.isOperatorFor(address(this), account),
      "ERC777FeeIncome: contract not an authorized operator of the given account."
    );
    this.operatorSend(account, address(this), feeAmount, data, operatorData);
    super._chargeFee(account, feeAmount);
  }
    
  function tokensReceived(
    address operator,
    address from,
    address to,
    uint amount,
    bytes calldata userData,
    bytes calldata operatorData
  ) external {
    require(
      msg.sender == address(this),
      "ERC777FeeIncome: only this contract can be the message sender" 
    );
  }
}
