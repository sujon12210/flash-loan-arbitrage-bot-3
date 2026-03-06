# Flash Loan Arbitrage Bot

A high-performance, flat-structure Solidity implementation for executing flash loans on Aave V3. This bot allows you to leverage deep liquidity to capture price discrepancies between DEXs (e.g., Uniswap vs. Sushiswap) in a single atomic transaction.

## Core Logic
* **Flash Loan**: Requests assets from the Aave Pool without upfront collateral.
* **Arbitrage Execution**: The `executeOperation` callback performs the trade logic.
* **Repayment**: The contract automatically calculates and returns the principal plus the 0.05% protocol fee.
* **Atomicity**: If the trade isn't profitable enough to cover the fee, the entire transaction reverts, ensuring no loss of principal.



## Security Features
* **OnlyPool Modifier**: Ensures the callback can only be triggered by the legitimate Aave Pool contract.
* **Withdrawal Logic**: Emergency function to retrieve any leftover profit (ERC20 or ETH) from the contract.

## Deployment
1. Update `PoolAddressesProvider` for your target network (Mainnet, Polygon, Arbitrum).
2. Deploy `FlashLoanArbitrage.sol`.
3. Fund the contract with enough gas (ETH) and a small amount of the base token to cover the initial flash loan fee.
