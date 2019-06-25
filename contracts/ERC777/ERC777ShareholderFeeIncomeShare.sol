pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/IERC777/IERC777.sol";
import "../ShareholderFeeIncomeShare.sol";

/**
 * @title ERC777ShareholderFeeIncomeShare
 */
contract ERC777ShareholderFeeIncomeShare is ShareholderFeeIncomeShare, IERC20 {

  struct TemporalValue {
    uint256 fromBlock;
    uint256 toBlock;
    uint256 value;
  }

  mapping(address => TemporalValue[]) private _balances;
  TemporalValue[] private _totalSupplies;

  function send(address to, uint256 amount, bytes calldata data) external {
    _updateBalance(msg.sender, balanceOf(msg.sender));
    _updateBalance(recipient, balanceOf(recipient));
    super.send(to, amount, data);
  }

  function operatorSend(
    address from,
    address to,
    uint256 amount,
    bytes calldata data,
    bytes calldata operatorData
  ) external {
    _updateBalance(from, balanceOf(from));
    _updateBalance(to, balanceOf(to));
    super.operatorSend(from, to, amount, data, operatorData);
  }
  
  function burn(uint256 amount, bytes calldata data) external {
    _updateTotalSupply(totalSupply());
    super.burn(amount, data);
  }
  
  function operatorBurn(
    address from, 
    uint256 amount,
    bytes calldata data,
    bytes calldata operatorData
  ) external {
    _updateTotalSupply(totalSupply());
    super.operatorBurn(from, amount, data, operatorData);
  }
}
