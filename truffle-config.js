module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
      gas: 4500000,
      gasPrice: 1,
    }
  },
  mocha: {
    useColors: true
  },
  solc: {
    optimizer: {
      enabled: true,
        runs: 200
    }
  }
};
