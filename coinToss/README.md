## Coin Toss

### Stages
- [simple.sol](simple.sol) works with a single transaction using an unsafe pseudorandom value.
- [coinToss.sol](coinToss.sol) works with two transactions using an external service to retrieve a random value.
- [client/main.js](client/main.js) is a simple web client using the MetaMask browser extension to access an [instance of coinToss.sol](https://rinkeby.etherscan.io/address/0x2dfa5cba4f3b738264b21a5748bb9d58c12e82fb) on the Rinkeby test network. 
