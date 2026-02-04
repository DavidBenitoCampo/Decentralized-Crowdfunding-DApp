// SPDX-License-Identifier: MIT
pragma solidity 0.8.20; // Do not change the solidity version as it negatively impacts submission grading

import "hardhat/console.sol";
import "./FundingRecipient.sol";

contract CrowdFund {
    /////////////////
    /// Errors //////
    /////////////////

	error NotOpenToWithdraw();
	error WithdrawTransferFailed(address to, uint256 amount);
	error TooEarly(uint256 deadline, uint256 currentTimestamp);
	error AlreadyCompleted();

    //////////////////////
    /// State Variables //
    //////////////////////

	bool public openToWithdraw;
	uint256 public deadline = block.timestamp + 30 seconds;
	uint256 public constant threshold = 1 ether;

    FundingRecipient public fundingRecipient;
	// Track individual balances
	mapping(address => uint256) public balances;


    ////////////////
    /// Events /////
    ////////////////

    event Contribution(address indexed contributor, uint256 amount);

    ///////////////////
    /// Modifiers /////
    ///////////////////

    modifier notCompleted() {
    	if (fundingRecipient.completed()) {
			revert AlreadyCompleted();
			}
		_;
    }

    ///////////////////
    /// Constructor ///
    ///////////////////

    constructor(address fundingRecipientAddress) {
        fundingRecipient = FundingRecipient(fundingRecipientAddress);
    }

    ///////////////////
    /// Functions /////
    ///////////////////

    function contribute() public payable notCompleted {
		// 1. Update the balance of the sender
		balances[msg.sender] += msg.value;
		// 2. Emit the event (using the names we discussed)
		emit Contribution(msg.sender, msg.value);
	}
	
	function withdraw() public notCompleted {
    // 1. Check if the contract state allows withdrawal
    	if (!openToWithdraw) {
        	revert NotOpenToWithdraw();
    	}

    // 2. Identify how much this specific user contributed
    	uint256 amount = balances[msg.sender];

    // 3. Reset the balance to 0 (Checks-Effects-Interactions pattern)
    	balances[msg.sender] = 0;

    // 4. Transfer the ETH back to the user
    	(bool success, ) = msg.sender.call{value: amount}("");

    // 5. If the transfer fails, revert the whole transaction
    	if (!success) {
        	revert WithdrawTransferFailed(msg.sender, amount);
    	}
	}

    function execute() public notCompleted {
		if (block.timestamp < deadline) {
			revert TooEarly(deadline, block.timestamp);
		}

		if (address(this).balance >= threshold) {
			fundingRecipient.complete{value: address(this).balance}();
		} else {
			openToWithdraw = true; 
		}
	}

    receive() external payable {
		contribute();
	}

    ////////////////////////
    /// View Functions /////
    ////////////////////////

    function timeLeft() public view returns (uint256) {
    	if (block.timestamp >= deadline) {
			return 0;	
		}
		return deadline - block.timestamp;
    }
}
