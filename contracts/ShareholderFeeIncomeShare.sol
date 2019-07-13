pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/Math.sol";

/**
 * @title ShareholderFeeIncomeShare
 */
contract ShareholderFeeIncomeShare {

  struct TemporalValue {
    uint256 fromBlock;
    uint256 toBlock;
    uint256 value;
  }

  mapping(address => TemporalValue[]) private _balances;
  TemporalValue[] private _totalSupplies;

  function getRelativeSharesFrom(address account, uint256 fromBlock) 
    external view returns (
      uint256[] memory fromBlocks,
      uint256[] memory toBlocks,
      uint256[] memory balances,
      uint256[] memory totalSupplies
    ) {
      uint i_bal = _balances[account].length - 1;
      uint i_ts = _totalSupplies.length - 1;
      uint minToBlock;
      uint maxFromBlock;
      for (uint i = 0; i_bal >= 0 && i_ts >= 0; i++) {
        maxFromBlock = Math.max(
          _balances[account][i_bal].fromBlock,
          _totalSupplies[i_ts].fromBlock
        );
        minToBlock = Math.min(
          _balances[account][i_bal].toBlock,
          _totalSupplies[i_ts].toBlock
        );
        fromBlocks[i] = maxFromBlock;
        toBlocks[i] = minToBlock;
        balances[i] = _balances[account][i_bal].value;
        totalSupplies[i] = _totalSupplies[i_ts].value;
        if (maxFromBlock <= fromBlock) {
          fromBlocks[i] = fromBlock;
          break;
        }
        if (_balances[account][i_bal].fromBlock == maxFromBlock) {
          i_bal--;
        }
        if (_totalSupplies[i_ts].fromBlock == maxFromBlock) {
          i_ts--;
        }
      }
    }

  /**
   *
   */
  function _updateBalance(address account, uint256 balance) internal {
    _balances[account].push(
      TemporalValue(
        _balances[account][_balances[account].length-1].fromBlock,
        block.number,
        balance
      )
    );
  }
  
  /**
   *
   */
  function _updateTotalSupply(uint256 totalSupply) internal {
    _totalSupplies.push(
      TemporalValue(
        _totalSupplies[_totalSupplies.length-1].fromBlock,
        block.number,
        totalSupply
      )
    );
  }
}
