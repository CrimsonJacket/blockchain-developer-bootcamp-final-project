require('dotenv').config()

const HDWalletProvider = require("@truffle/hdwallet-provider");
const INFURA_ID = process.env.INFURA_ID

const fs = require('fs');
const MNEMONIC = fs.readFileSync('.secret').toString().trim();

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a development blockchain for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    // Useful for testing. The `development` name is special - truffle uses it by default
    // if it's defined here and no other network is specified at the command line.
    // You should run a client (like ganache-cli, geth or parity) in a separate terminal
    // tab if you use this network and you must also set the `host`, `port` and `network_id`
    // options below to some value.
    //
    // development: {
    //  host: "127.0.0.1",     // Localhost (default: none)
    //  port: 7545,
    //  network_id: "*",       // Any network (default: none)
    // },
    local: {
      host: "localhost",
      port: 8545,
      chainId: 1337,
      network_id: "*"
    },
    kovan: {
      provider: function() {
        return new HDWalletProvider(MNEMONIC, `https://kovan.infura.io/v3/${INFURA_ID}`)
      },
      network_id: 42
    }

  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.10",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
  },

};
