It works both on Goerli Testnet and Ethereum Mainnet

How to deploy
1.npm install
2.truffle develop
3.
(Testnet)
migrate --reset --network goerli
(Mainnet)
migrate --reset --network ethereum
4.
(Testnet)
run verify Miragrow --network goerli
(Mainnet)
run verify Miragrow --network ethereum