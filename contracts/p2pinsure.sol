pragma solidity ^0.4.11;

contract P2pinsure {
    uint public premium;
    address public adjudicator;
    mapping(address => uint)  members;
    mapping(address => uint)  claims;
    uint totalValue;
    mapping(address => uint) votesForClaim;
    bool voting;

    event Claim(address claiment, uint amount);

    function create(address _adjudicator, bool _voting) {
        premium = 10;
        adjudicator = _adjudicator;
        voting = _voting;
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

    function isMember()
        returns (bool isMember)
    {
       var person = msg.sender;

        if(members[person] != 0)
            return true;
    }
}
