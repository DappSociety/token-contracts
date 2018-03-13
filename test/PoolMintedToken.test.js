let Token = artifacts.require("./PoolMintedTokenMock.sol");
let Minter = artifacts.require("./Minter.sol");

contract('Token', async (accounts) => {
  it ('should set minter and mint 100 tokens per second', async () => {
    let initialSupply = 1000
    let secondsElapsed = 10
    let tokensPerSecond = 100
    let expectedAmount = initialSupply+secondsElapsed*tokensPerSecond

    let token = await Token.deployed()
    let minter = await Minter.deployed()

    await token.setMinterContract(minter.address)
    await token.mintNewTokens()

    let poolBalance = await token.balanceOf.call(token.address)
    poolBalance = poolBalance.toNumber()

    // Allow for 1 second variance
    if (poolBalance === expectedAmount + tokensPerSecond) poolBalance -= tokensPerSecond

    assert.isTrue(poolBalance === expectedAmount)
  })

  it ('should set pool manager and transfer from pool', async () => {
    let accountOne = accounts[0]
    let accountTwo = accounts[1]
    let amountToTransfer = 1000
    let token = await Token.deployed()

    // Get initial pool balance
    let initialPoolBalance = await token.balanceOf.call(token.address)
    initialPoolBalance = initialPoolBalance.toNumber()

    await token.setPoolManager(accountOne, true)
    await token.transferFromPool(accountTwo, amountToTransfer)

    let accountTwoBalance = await token.balanceOf.call(accountTwo)
    accountTwoBalance = accountTwoBalance.toNumber()
    let poolBalance = await token.balanceOf.call(token.address)
    poolBalance = poolBalance.toNumber()

    assert.isTrue(
      (accountTwoBalance === amountToTransfer) &&
      (poolBalance === initialPoolBalance - amountToTransfer)
    )
  })

  it ('should unset pool manager and prevent unauthorized transfer from pool', async () => {
    let accountOne = accounts[0];
    let accountTwo = accounts[1];
    let token = await Token.deployed();

    // Get initial pool balance
    let initialPoolBalance = await token.balanceOf.call(token.address);
    initialPoolBalance = initialPoolBalance.toNumber();
    assert.isTrue(initialPoolBalance > 0);

    // Sender must be a pool manager
    await token.setPoolManager(accountOne, false);
    try { await token.transferFromPool(accountTwo, initialPoolBalance) }
    catch (error) { /* expected */ }

    // Can't send more than the pool balance
    await token.setPoolManager(accountOne, true);
    try { await token.transferFromPool(accountTwo, initialPoolBalance+1) }
    catch (error) { /* expected */ }

    let poolBalance = await token.balanceOf.call(token.address);
    poolBalance = poolBalance.toNumber();

    assert.isTrue(poolBalance === initialPoolBalance)
  })

});
