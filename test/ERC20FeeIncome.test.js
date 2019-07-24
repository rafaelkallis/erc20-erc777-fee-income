/**
 * @file erc20feeincome tests
 * @author Rafael Kallis <rk@rafaelkallis.com>
 */

const { BN } = require("openzeppelin-test-helpers");
const { expect } = require("chai");

const ERC20FeeIncomeMock = artifacts.require("ERC20FeeIncomeMock");

contract("ERC20FeeIncome", (accounts) => {

  const owner = accounts[1];
  const user = accounts[2];

  let token;

  it("mint fee", async () => {
    token = await ERC20FeeIncomeMock.new(
      new BN(10).pow(new BN(17)), // 10% transfer fee
      new BN(10).pow(new BN(17)), // 10% mint fee
      0,
      { from: owner }
    );
    await token.approve(
      token.address,
      100 * 1000 * 1000,
      { from: owner }
    );
    await token.mint(
      owner, 
      1000 * 1000 * 1000, 
      { from: owner }
    );

    assert.equal(1000 * 1000 * 1000, await token.totalSupply());
    assert.equal( 900 * 1000 * 1000, await token.balanceOf(owner));
    assert.equal( 100 * 1000 * 1000, await token.balanceOf(token.address));

    assert.equal( 100 * 1000 * 1000, await token.outstandingFees());
  });
  
  it("transfer fee", async () => {
    token = await ERC20FeeIncomeMock.new(
      new BN(10).pow(new BN(17)), // 10% transfer fee
      0,
      0,
      { from: owner }
    );
    await token.mint(
      owner, 
      new BN("1 000 000 000"), 
      { from: owner }
    );

    await token.approve(
      token.address,
      new BN("100 000"),
      { from: owner }
    );
    await token.transfer(
      user,
      new BN("1 000 000"),
      { from: owner }
    );
    
    expect(new BN("1 000 000 000")).to.be.bignumber.equal(await token.totalSupply());
    expect(new BN("  998 900 000")).to.be.bignumber.equal(await token.balanceOf(owner));
    expect(new BN("    1 000 000")).to.be.bignumber.equal(await token.balanceOf(user));
    expect(new BN("      100 000")).to.be.bignumber.equal(await token.balanceOf(token.address));

    expect(new BN("      100 000")).to.be.bignumber.equal(await token.outstandingFees());
  });
});
