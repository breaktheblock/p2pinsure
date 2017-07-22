pragma solidity ^0.4.11;

contract P2pinsure {
    uint public premium;
    address public adjudicator;
    mapping(address => uint)  members;
    uint totalValue;


    function create(uint _premium, address _adjudicator) {
        premium = _premium;
        adjudicator = _adjudicator;
    }

    function adjudicate(){}

    function join() payable {
       address person = msg.sender;
       require(person != adjudicator
                && members[person] != 0);

    }

    function claim(){
       address person = msg.sender;
       //address person = addr;
       person.transfer(1000000000000000000);
       if(members[person] != 0){
       }
    }

    function payout(){

    }

    function isMember()
        returns (bool isMember)
    {
       var person = msg.sender;

        if(members[person] != 0)
            return true;
    }
}
