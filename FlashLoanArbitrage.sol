// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title FlashLoanArbitrage
 * @dev Implementation of a simple Aave V3 Flash Loan receiver.
 */
contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase, Ownable {
    
    constructor(address _addressProvider) 
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) 
        Ownable(msg.sender)
    {}

    /**
     * @dev The function Aave calls after giving you the loan.
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // 1. ARBITRAGE LOGIC GOES HERE
        // Example: Swap 'amount' of 'asset' on DEX A, then swap back on DEX B.
        
        // 2. Ensure we have enough to pay back the loan + premium
        uint256 amountToReturn = amount + premiums;
        require(IERC20(asset).balanceOf(address(this)) >= amountToReturn, "Arbitrage not profitable");
        
        // 3. Approve Aave to pull the repayment
        IERC20(asset).approve(address(POOL), amountToReturn);

        return true;
    }

    /**
     * @dev Trigger the flash loan
     */
    function requestFlashLoan(address _token, uint256 _amount) public onlyOwner {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    function withdraw(address _token) external onlyOwner {
        IERC20 token = IERC20(_token);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    receive() external payable {}
}
