pragma solidity ^0.4.11;

//importing the files associated with oraclize
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Betting is usingOraclize {
    //declaring public varibales
	string public description;
	address[] private addresses;
	uint public amount;
	uint public pot;
	string[] private numbers;
	string RandomNumber;
	bool private equal;
	mapping (address => uint) participating;

//events
	event betAccpeted(address gambler, uint amount);
	event Winner(address winner, uint _pot);
	event rollAccpeted(address better, string _number);
	
//functions
//Betting function is called when the contract is created 
    function Betting (string _description, uint amount_In_Ether) {
        description = _description;
        amount = amount_In_Ether * 1 ether;
    }
  
 //second function is used to send ether to the contract and the bet number
	function sendNumberAndAmount (string _numberInRangeOf0To1) payable {
	    if (msg.value == amount && participating[msg.sender] == 0) {
	       	pot += msg.value;
				//an array to hold addresses of betters
	       	addresses.push(msg.sender);
				//an array to hold numbers numbers of betters
            numbers.push(_numberInRangeOf0To1);
	       	participating[msg.sender] += 1;
	        betAccpeted(msg.sender, msg.value);
	        rollAccpeted(msg.sender, _numberInRangeOf0To1);
	    } else {
	        throw; //throws if the same person bets against themselves or if they send no ether
	    }
	}
	
//setRandomNumber function calls update to send a request to Oracle network
	function setRandomNumber() payable {
        oraclize_query("WolframAlpha", "RandomInteger[{0,1}]"); //this query uses WolframAlpha        
    }
    
//callback function is used to get the results from Oracle
    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;
        RandomNumber = result;
    }
    
//oracle api send a sting back, stringsEqual function is used to see if they are the same
	function stringsEqual (string input) {
		//turning the string to bytes
		bytes storage a = bytes(RandomNumber);
		bytes memory b = bytes(input);
		uint c = 2;
		//checks if leghts are equal
		if (a.length != b.length) {
			equal = false;
			c--;
	    }
	    //checks if values of bytes are equal
	    for(uint i; i < a.length; i++ ) {
	        if (a[i] != b[i]) {
	            equal = false;
	            c--;
	        }
	    }
	    //check to see if all conditions are met
	    if (c == 2) {
	        equal = true;
	    }
	}
	
//checkingWinner function is called when you want to compare RandomNumber to betting numbers
	function checkingWinner () {
	    bool win = false;
	    uint x = 0;
			//takes random number generated at wolframAlpha and compares it to the betting number
	    while (win == false) {
	        stringsEqual(numbers[x]);
            if (equal == true) {
	            addresses[x].transfer(pot);
	            Winner(addresses[x], pot);
	            win = true;
	        } else {
	            x++;
	        }
	    }
	}
}
