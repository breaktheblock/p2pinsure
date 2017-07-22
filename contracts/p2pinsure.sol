pragma solidity ^0.4.11;

contract Policy {
    uint public premium;
    address public adjudicator;
    mapping(address => bool)  members;
  
    function create(uint _premium, address _adjudicator) {
        premium = _premium;
        adjudicator = _adjudicator;
    }
    
    function adjudicate(){}
    
    function join(){
       var person = msg.sender;
       
       if(msg.sender != adjudicator && !members[person]){
            members[person] = true;
        }
       
       // what if person already
    }
    
    function claim(){
    }
    
    function payout(){
    
    }
    
    function isMember()
        returns (bool isMember)
    {
       var person = msg.sender;
           
        if(members[person])
            return true;
    }
}