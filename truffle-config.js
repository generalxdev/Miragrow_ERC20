require("dotenv").config();
const { MNEMONIC, PROJECT_ID } = process.env;

const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
    plugins: [
    'truffle-plugin-verify'
    ],
    api_keys: {
        etherscan: 'P82UE1X5UQ6457KFUXXTF4F7W2Z9YZ7X4M'
    },
    networks: {
        development: {
            host: "127.0.0.1", // Localhost (default: none)
            port: 9545, // Standard Ethereum port (default: none)
            network_id: "*", // Any network (default: none)
        },   
        goerli: {
            provider: () =>
                new HDWalletProvider(
                    MNEMONIC,
                    `https://goerli.infura.io/v3/${PROJECT_ID}`,
                ),
            network_id: 5, // Goerli's id
            confirmations: 2, // # of confirmations to wait between deployments. (default: 0)
            timeoutBlocks: 200, // # of blocks before a deployment times out  (minimum/default: 50)
            skipDryRun: true, // Skip dry run before migrations? (default: false for public nets )
        },
        ethereum: {
            port: 80,
            provider: () =>
            new HDWalletProvider(
                MNEMONIC,
                `https://mainnet.infura.io/v3/8f9322b9403748a5bc072d82941df7de`,
            ),
            network_id: 1,
            confirmations: 2, // # of confirmations to wait between deployments. (default: 0)
            timeoutBlocks: 2000, // # of blocks before a deployment times out  (minimum/default: 50)
            skipDryRun: true, // Skip dry run before migrations? (default: false for public nets )
            production:true,
            //  gas: 3000000,
            //  gasPrice: 2000000000000 //set here like 0,02ETH
            //  gas: 8000000,           // Gas limit used for deploys
            //  gasPrice: 120000000000, // 120 gwei (in wei) (default: 100 gwei)
        },
        fantom: {
            provider: () =>
                new HDWalletProvider(
                    MNEMONIC,
                    `https://rpc.ankr.com/fantom_testnet`,
                ),
            network_id: 4002, // Goerli's id
            confirmations: 2, // # of confirmations to wait between deployments. (default: 0)
            timeoutBlocks: 200, // # of blocks before a deployment times out  (minimum/default: 50)
            skipDryRun: true, // Skip dry run before migrations? (default: false for public nets )
        },
    },
    compilers: {
        solc: {
            version: "0.8.17",
        },
    },
};
