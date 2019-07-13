pragma solidity ^0.5.0;

import "./ShareholderFeeIncomeShare.sol";
import "./FeeIncome.sol";

/**
 * @title ShareholderFeeIncome
 */
contract ShareholderFeeIncome is FeeIncome {

  ShareholderFeeIncomeShare private _shares;
  mapping(address => uint256) private _lastCollectionBlock;

  constructor(ShareholderFeeIncomeShare shares) public {
    require(address(shares) != address(0), "ShareholderFeeIncome: shares is the zero address");
    _shares = shares;
  }

  function _computeAndClearFees() internal returns (uint256) {
    (
      uint256[] memory fromBlocks,
      uint256[] memory toBlocks,
      uint256[] memory balances,
      uint256[] memory totalSupplies
    ) = _shares.getRelativeSharesFrom(msg.sender, _lastCollectionBlock[msg.sender]);
    assert(fromBlocks.length == toBlocks.length);
    assert(toBlocks.length == balances.length);
    assert(balances.length == totalSupplies.length);
    uint256 collectedFees = 0;
    for (uint i_rs = 0; i_rs < fromBlocks.length; i_rs++) {
      uint256 collectedFees_rs = 0;
      for (uint i_b = fromBlocks[i_rs]; i_b < toBlocks[i_rs]; i_b++) {
        for (uint i_f = 0; i_f < blockFees(i_b).length; i_f++) {
          collectedFees_rs += blockFees(i_b)[i_f];
        } 
      }
      collectedFees += collectedFees_rs.mul(balances[i_rs]).div(totalSupplies[i_rs]);
    }
    _lastCollectionBlock[msg.sender] = block.number;
    return collectedFees;
  }

  function shares() public view returns (ShareholderFeeIncomeShare) {
    return _shares;
  }

  function lastCollectionBlock(address account) public view returns (uint256) {
    return _lastCollectionBlock[account];
  }
}
