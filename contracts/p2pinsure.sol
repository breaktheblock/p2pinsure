pragma solidity ^0.4.11;

contract P2pinsure {
    uint public premium;
    uint public quorumMultiplier;
    address public adjudicator;
    address public owner;
    uint public memberCount;
    mapping(address => uint)  members;
    mapping(address => uint64)  claims;
    mapping(address => mapping(address => bool)) claimantVoterMap;
    mapping(address => bool) public joinRequests;
    bool public voting;
    uint public totalValue;
    mapping(address => uint) votesForClaim;
    mapping(address => bool) whitelist;
    string public policyName;
    uint public maxPoolSize;
    // joingCriteria 1 == Open, 2 == Voting, 3 == Owner, Anyother number is  voting not implemented yet
    uint public joiningCriteria;


    event Claim(address claimant, uint amount);
    event Vote(address claimant, address voter, bool choice);
    event Payout(address claimant, uint amount);


//
    function P2pinsure(address _adjudicator, bool _isVotingResolutionMethod,
                    string _policyName, uint _maxPoolSize, uint _joiningCriteria){
        // _joiningCriteria - open, owner approval, voting
        // max pool size
        owner = msg.sender;
        premium = 10;
        adjudicator = _adjudicator;
        voting = _isVotingResolutionMethod;
        quorumMultiplier = 2;
        policyName = _policyName;
        maxPoolSize = _maxPoolSize;
        joiningCriteria = _joiningCriteria;
    }

    function adjudicate(address claimant, bool approve, uint negative_adjustment){
        require(msg.sender == adjudicator && voting == false);
        if(approve){
            uint amount = claims[claimant] - negative_adjustment;
            claimant.transfer(amount);
        }
    }


    function ownerWhitelist(address requestingAddress) {
        require(msg.sender == owner);
        if(joiningCriteria == 1) {
            whitelist[requestingAddress] = true;
        }

    }

    function join() payable whiteListCheck(msg.sender) {
       address person = msg.sender;
       require(person != adjudicator
                && members[person] == 0
                && msg.value > premium
                && memberCount < maxPoolSize);
       members[person] = msg.value;
       totalValue += msg.value;
       memberCount += 1;
    }

    function claim(uint64 amount){
       address person = msg.sender;
       require(members[person] > 0);
       claims[person] = amount;
       Claim(person, amount);
    }

    function vote(address claimant){
        require(voting == true && claimantVoterMap[claimant][msg.sender] != true);
        votesForClaim[msg.sender] += 1;
        claimantVoterMap[claimant][msg.sender] = true;
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

    modifier whiteListCheck(address requestingMember) {
        if(joiningCriteria != 1) {
        require(whitelist[requestingMember] == true);
        }
        _;
    }

}
