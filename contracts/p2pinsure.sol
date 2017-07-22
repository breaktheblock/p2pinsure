pragma solidity ^0.4.11;

contract P2pinsure {
    uint public premium;
    uint public quorumMultiplier;
    address public adjudicator;
    mapping(address => uint)  members;
    uint public memberCount;
    mapping(address => uint)  claims;
    mapping(address => mapping(address => bool)) claimantVoterMap;
    bool public voting;
    uint public totalValue;
    mapping(address => uint) votesForClaim;
    string public policyName;


    event Claim(address claimant, uint amount);
    event Vote(address claimant, address voter, bool choice);
    event Payout(address claimant, uint amount);

    function create(address _adjudicator, bool _voting, string _policyName) {
        premium = 10;
        adjudicator = _adjudicator;
        voting = _voting;
        quorumMultiplier = 2;
        policyName = _policyName;
    }

    function adjudicate(address claimant, bool approve, uint negative_adjustment){
        require(msg.sender == adjudicator && voting == false);
        if(approve){
            uint amount = claims[claimant] - negative_adjustment;
            claimant.transfer(amount);
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
        require(voting == true && claimantVoterMap[claimant][msg.sender] != true);
        votesForClaim[msg.sender] += 1;
        claimant_voter_map[claimant][msg.sender] = true;
    }

    function check_payout(){
        require(voting == true && claims[msg.sender] > 0);
        if (votesForClaim[msg.sender] * quorumMultiplier > memberCount) {
            msg.sender.transfer(claims[msg.sender]);
        }
    }

    function  isMember() returns (bool isMember) {
       var person = msg.sender;
        if(members[person] != 0)
            return true;
    }
}
