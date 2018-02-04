pragma solidity ^0.4.19;

contract Accountability {
//variables
  string public description;
  address public productCreator;
  address public seller;
  uint public amount;
  uint public price  = 10 ether;
  mapping (address => uint) public productExchange;

//events
  event sold (address buyer, uint amountBought);

//function to create the contract
  function Accountability (uint _amount, string _description) {
        description = _description;
        amount = _amount;
        seller = msg.sender;
        productCreator = msg.sender;
  }

//function to buy the product
  function buy (uint buyAmount) payable {
        //check to is if the product is sold out and the msg.value is enough to buy
        if (msg.value >= (price * buyAmount) && amount > 0){
            productExchange[msg.sender] += (buyAmount);
            productExchange[seller] -= (buyAmount);
            sold(msg.sender, buyAmount);
        } else {
            throw;
        }
  }
}
