pragma solidity ^0.4.11;

contract P2pinsure {
    uint public premium;
    address public adjudicator;
    mapping(address => uint)  members;
    mapping(address => uint)  claims;
    uint totalValue;

    event Claim(address claiment, uint amount);

    function create(uint _premium, address _adjudicator) {
        premium = _premium;
        adjudicator = _adjudicator;
    }

    function adjudicate(address claimant, bool approve){
        require(msg.sender == adjudicator);
        if(approve){
            claimant.transfer(claims[claimant]);
        }
    }

    function join() payable {
       address person = msg.sender;
       require(person != adjudicator
                && members[person] == 0
                && msg.value > premium);
       members[person] = msg.value;
    }

    function claim(uint amount){
       address person = msg.sender;
       require(members[person] > 0);
       claims[person] = amount;
       Claim(person, amount);
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
