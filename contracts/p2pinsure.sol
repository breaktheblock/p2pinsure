pragma solidity ^0.4.11;

contract P2pinsure {
    uint public premium;
    uint public quorum_multiplier;
    address public adjudicator;
    mapping(address => uint)  members;
    uint public memberCount;
    mapping(address => uint)  claims;
    mapping(address => mapping(address => bool)) claimant_voter_map;
    bool public voting;
    uint public totalValue;
    mapping(address => uint) votesForClaim;

    event Claim(address claiment, uint amount);
    event Vote(address claiment, address voter, bool choice);
    event Payout(address claiment, uint amount);

    function create(address _adjudicator, bool _voting) {
        premium = 10;
        adjudicator = _adjudicator;
        voting = _voting;
        quorum_multiplier = 2;
    }

    function adjudicate(address claimant, bool approve){
        require(msg.sender == adjudicator && voting == false);
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
       totalValue += msg.value;
       memberCount += 1;
    }

    function claim(uint amount){
       address person = msg.sender;
       require(members[person] > 0);
       claims[person] = amount;
       Claim(person, amount);
    }

    function vote(address claimant){
        require(voting == true && claimant_voter_map[claimant][msg.sender] != true);
        votesForClaim[msg.sender] += 1;
        claimant_voter_map[claimant][msg.sender] = true;
    }

    function check_payout(){
        require(voting == true && claims[msg.sender] > 0);
        if (votesForClaim[msg.sender] * quorum_multiplier > memberCount) {
            msg.sender.transfer(claims[msg.sender]);
        }
    }

    function  isMember() returns (bool isMember) {
       var person = msg.sender;

        if(members[person] != 0)
            return true;
    }
}
