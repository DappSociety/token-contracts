let Token = artifacts.require("./PoolMintedTokenMock.sol");
let Minter = artifacts.require("./Minter.sol");

let token;
let minter;

contract('Token', async (accounts) => {
  it ('should set minter and mint 100 tokens per second', async () => {
    token = await Token.deployed()
    minter = await Minter.deployed()

    let initialSupply = 1000
    let secondsElapsed = 10
    let tokensPerSecond = 100
    let expectedAmount = initialSupply+secondsElapsed*tokensPerSecond

    await token.setMinterContract(minter.address)
    await token.mintNewTokens()

    let poolBalance = await token.balanceOf.call(token.address)
    poolBalance = poolBalance.toNumber()

    // Allow for 1 second variance
    if (poolBalance === expectedAmount + tokensPerSecond) poolBalance -= tokensPerSecond

    assert.isTrue(poolBalance === expectedAmount)
  })

  it ('should set pool manager and transfer from pool', async () => {
    let amountToTransfer = 1000

    // Get initial pool balance
    let initialPoolBalance = await token.balanceOf.call(token.address)
    initialPoolBalance = initialPoolBalance.toNumber()

    await token.setPoolManager(accounts[0], true)
    await token.transferFromPool(accounts[1], amountToTransfer)

    let accountTwoBalance = await token.balanceOf.call(accounts[1])
    accountTwoBalance = accountTwoBalance.toNumber()
    let poolBalance = await token.balanceOf.call(token.address)
    poolBalance = poolBalance.toNumber()

    assert.isTrue(
      (accountTwoBalance === amountToTransfer) &&
      (poolBalance === initialPoolBalance - amountToTransfer)
    )
  })

  it ('should unset pool manager and prevent unauthorized transfer from pool', async () => {

    // Get initial pool balance
    let initialPoolBalance = await token.balanceOf.call(token.address);
    initialPoolBalance = initialPoolBalance.toNumber();
    assert.isTrue(initialPoolBalance > 0);

    // Sender must be a pool manager
    await token.setPoolManager(accounts[0], false);
    try { await token.transferFromPool(accounts[1], initialPoolBalance) }
    catch (error) { /* expected */ }

    // Can't send more than the pool balance
    await token.setPoolManager(accounts[0], true);
    try { await token.transferFromPool(accounts[1], initialPoolBalance+1) }
    catch (error) { /* expected */ }

    let poolBalance = await token.balanceOf.call(token.address);
    poolBalance = poolBalance.toNumber();

    assert.isTrue(poolBalance === initialPoolBalance)
  })
});
