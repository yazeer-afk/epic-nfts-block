require("@nomiclabs/hardhat-waffle");
require("dotenv").config()

module.exports = {
  solidity: {
    compilers: [
        {
            version: "0.8.0"
        },
        {
            version: "0.8.1"
        }
    ]
  },
  networks: {
    rinkeby: {
      url: process.env.ALCHEMY_API_URL,
      accounts: [process.env.RINKEBY_ACCOUNT_KEY],
    },
  },
};
