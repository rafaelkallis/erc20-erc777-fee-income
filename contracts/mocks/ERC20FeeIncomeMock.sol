pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "../ERC20/ERC20TransferFee.sol";
import "../ERC20/ERC20MintFee.sol";
import "../ERC20/ERC20BurnFee.sol";
import "../SingleOwnerFeeIncome.sol";

/**
 * @title ERC20FeeIncomeMock
 * @author Rafael Kallis <rk@rafaelkallis.com>
 */
contract ERC20FeeIncomeMock is ERC20, SingleOwnerFeeIncome, ERC20TransferFee, ERC20Mintable, ERC20MintFee, ERC20Burnable, ERC20BurnFee {

  constructor(
    uint256 transferFee,
    uint256 mintFee,
    uint256 burnFee
  ) public 
    ERC20TransferFee(transferFee)
    ERC20MintFee(mintFee)
    ERC20BurnFee(burnFee) {}

  function transfer(address to, uint256 amount) public returns (bool) {
    require(super.transfer(to, amount));
    if (msg.sender != address(this)) {
      _chargeTransferFee(msg.sender, amount);
    }
    return true;
  }
  
  function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
    require(super.transferFrom(sender, recipient, amount));
    if (msg.sender != address(this)) {
      _chargeTransferFee(sender, amount);
    }
    return true;
  }

  function mint(address account, uint256 amount) public returns (bool) {
    require(super.mint(account, amount));
    _chargeMintFee(msg.sender, amount);
    return true;
  }

  function burn(uint256 amount) public {
    super.burn(amount);
    _chargeBurnFee(msg.sender, amount);
  }
  
  function burnFrom(address account, uint256 amount) public {
    super.burnFrom(account, amount);
    _chargeBurnFee(account, amount);
  }
}
