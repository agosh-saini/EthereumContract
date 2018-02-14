pragma solidity ^0.4.19;

//This is a Betting smart contract that I created to learn how to make
//random numbers using oraclizeAPI

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Betting is usingOraclize {
	//declaring public varibales
	string public description;
	address public winner;
	address[] private addresses;
	uint public amount;
	uint public pot;
	uint private numParticipating;
	bytes32[] private numbers;
	bytes32 RandomNumber;
	mapping (address => uint) participating;

//events
	event betAccpeted(address gambler, uint amount);
	event Winner(address winner, uint _pot);
	event rollAccpeted(address better);


//functions
	function Betting (string _description, uint _amount_in_ether) {
		description = _description;
		amount = _amount_in_ether * 1 ether;
	}

	function sendAmount (bytes32 _numberInRangeOf0To1) payable {
	    if (msg.value == amount && participating[msg.sender] == 0) {
	       	pot += msg.value;
					//made an array to hold addresses
	       	addresses.push(msg.sender);
					//made an array to hold numbers
            numbers.push(_numberInRangeOf0To1);
	       	participating[msg.sender] += 1;
	        betAccpeted(msg.sender, msg.value);
	        rollAccpeted(msg.sender);
	    } else {
	        throw;
	    }
	}


	function checkingWinner () payable {
	    uint win = 0;
	    uint x = 0;
			//takes random number generated at wolframAlpha and sends to the contract
	    RandomNumber = oraclize_query("WolframAlpha", "RandomInteger[{0,1}]");
	    while (win == 0) {
			//checks the arrays to see who won
	        if (numbers[x] == RandomNumber) {
	            winner = addresses[x];
	            winner.send(pot);
	            Winner(winner, pot);
	            win = 1;
	        } else {
	            x++;
	        }
	    }
	}
}
