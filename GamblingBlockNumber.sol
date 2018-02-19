pragma solidity ^0.4.19;

//NO NUMBER CREATED ON THE BLOCKCHAIN IS TRULY RANDOM
//"RANDOM" NUMBER IS PREDETERMINED

contract Betting {
	//declaring public varibales
	string public description;
	address public winner;
	address[] private addresses;
	uint public amount;
	uint public pot;
	uint private RandomNumber;
	uint[] private numebers;
	mapping (address => uint) participating;

//events
	event betAccpeted(address gambler, uint amount);
	event Winner(address winner, uint _pot);
	event rollAccpeted(address better);


//functions
//betting function called when contract is created
	function Betting (string _description, uint _amount_in_ether) {
		description = _description;
		amount = _amount_in_ether * 1 ether;
	}

//used to send betting number and ether to the contract
	function sendAmount (uint _numberInRangeOf0To1) payable {
	    if (msg.value == amount && participating[msg.sender] == 0) {
	       	pot += msg.value;
	       	addresses.push(msg.sender);
          numebers.push(_numberInRangeOf0To1);
	       	participating[msg.sender] += 1;
	        betAccpeted(msg.sender, msg.value);
	        rollAccpeted(msg.sender);
	    } else {
	        throw;
	    }
	}

//checks for winners
	function checkingWinner () payable {
	    RandomNumber = block.numeber % 2; //uses timestamp of previous block to generate random number
	    uint win = 0;
	    uint x = 0;
	    while (win == 0) {
	        if (numebers[x] == RandomNumber) {
					//checks using the arrays created to see where the address  of the winner is located
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
