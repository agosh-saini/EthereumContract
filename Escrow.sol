pragma solidity ^0.4.0;

contract Escrow {
    
    // Declaring DIfferent states of the transaction
    enum State {AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE, REFUNDED}
    
    // modifiers
    modifier buyerOnly() {
        require(msg.sender == buyer || msg.sender == arbiter);
        _;
    }
    
    modifier sellerOnly() {
        require(msg.sender == seller || msg.sender == arbiter);
        _;
    }
    
    modifier inState (State expectedState) {
        require(currentState == expectedState);
        _;
    }
    
    //public varibles 
    State public currentState;
    address public buyer;
    address public seller;
    address public arbiter;
    
    //stakeholders
    function Escrow (address _buyer, address _seller, address _arbiter) {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
    }
    
    // Confirming Payment 
    function confirmPayment() buyerOnly inState(State.AWAITING_PAYMENT) payable {
        currentState == State.AWAITING_DELIVERY;
    }
    
    //confirming delivery 
    function confirmingDelivery() buyerOnly inState(State.AWAITING_DELIVERY) {
        seller.send(this.balance);
        currentState = State.COMPLETE;
    }
    
    //Refund Buyer 
    function refundBuyer () sellerOnly inState(State.AWAITING_DELIVERY) {
        buyer.send(this.balance);
        currentState = State.REFUNDED;
    }
}
