pragma solidity ^0.4.11;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Escrow is usingOraclize{

    //public varibles 
    address public creator;
    string public date_in_future;
    string public currentDate;
    uint public etherFund;
    bool public equal;
    
    
    //logs
    event newOraclizeQuery(string description);
    event escrowConfirmed(string descriptionEscrow);
    event escrowDelievered(string descriptionDelivery);
    event escrowFail(string descriptionFailure);
    
/*
IMPORTANT NOTICE: FAILURE TO FOLLOW INSTRUCTION WILL RESULT IN FUNDS BEING LOST
FORMAT FOR DATE ENTERY: Day, Month date, year
EXAMPLE: Thursday, May 10, 2018
THIS CONTRACTED HAS TO BE EXECUTED THE DATE YOU INPUTED AS "DATE IN FUTURE" OR END DATE OF THE ESCROW
*/
    
    
    //sets up the conract and takes in relevent information regarding the contract
    function Escrow (string _date_in_future, uint _etherFund) {
        creator = msg.sender;
        date_in_future = _date_in_future;
        etherFund = _etherFund * 1 ether;
    }
    
    // Confirming Creation of the escrow
    function confirmEscrow() payable {
       if (msg.sender != creator) throw;
       require(msg.value == etherFund);
       escrowConfirmed("An escrow has been created");
    }
    
    //finishing the escorw
    function finishEscrow() payable {
        if (msg.sender != creator) throw; 
        checkingResults(currentDate);
        if (equal == true) {              //checks if date today is the escrow finish date
            creator.transfer(etherFund);  
            escrowDelievered("Fund in Ecrow have been delivered to the addresss of the Reciever");
        } else {
            escrowFail("Transaction cannot be completed due to escrow conditions not being met");
        }
    }
    
    //checks date
    function checkDate() payable {
        update();
    }

    //Compares the strings inputed and the result from Oraclize
    function checkingResults (string input) {
        //turning the string to bytes
		bytes storage a = bytes(date_in_future);
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
    
    //Oraclize Callback function
    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;
        currentDate = result;
    }

    //Calling Oraclize Query    
    function update() payable {
        newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
        oraclize_query("WolframAlpha", "Today in Toronto");
    }
}