pragma solidity ^0.4.19;

//NO NUMBER CREATED ON THE BLOCKCHAIN IS TRULY RANDOM
//"RANDOM" NUMBER IS PREDETERMINED

contract Betting {
	//declaring public varibales
	string public description;
	address public validator;
	address public winner;
	address[] private addresses;
	uint public amount;
	uint public pot;
	uint private numParticipating;
	uint private validatorNumber;
	uint[] private numebers;
	mapping (address => uint) participating;

//events
	event betAccpeted(address gambler, uint amount);
  event validatorSet(address validator);
	event Winner(address winner, uint _pot);
	event rollAccpeted(address better, uint _number);

//modifiers
	modifier betterOnly () {
	    require(msg.sender != validator);
	    _;
	}

	modifier validatorOnly () {
	    require(msg.sender == validator);
	    _;
	}

//functions
//betting function called when contract is created
	function Betting (string _description, uint _amount_in_ether) {
		description = _description;
		amount = _amount_in_ether * 1 ether;
	    validator = msg.sender;
	    validatorSet(msg.sender);
	}

//used to send ether to contract
	function sendAmount () betterOnly() payable {
	    if (msg.value == amount && participating[msg.sender] == 0 && participating[validator] == 0) {
	       	pot += msg.value;
	       	participating[msg.sender] += 1;
	        betAccpeted(msg.sender, msg.value);
	    } else {
	        throw;
	    }
	}

//roll function is used to set the vaildator number and set betting numbers
	function roll (uint _numberInRangeOf0To1) {
	    if ((_numberInRangeOf0To1 >= 0 || _numberInRangeOf0To1 <= 1) && msg.sender != validator) {
            addresses.push(msg.sender);
            numebers.push(_numberInRangeOf0To1);
            rollAccpeted(msg.sender, _numberInRangeOf0To1);
        }
        if (msg.sender == validator) {
            validatorNumber = _numberInRangeOf0To1;
            rollAccpeted(validator, _numberInRangeOf0To1);
        }
	}

	//checks to see who won
	function checkingWinner () payable validatorOnly() {
	    uint win = 0;
	    uint x = 0;
	    while (win == 0) {
			//compares the betting numbers to that of the validators
	        if (numebers[x] == validatorNumber) {
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
