// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract Voter{

    struct OptionPos{
        uint pos;
        bool exists;
    }

    uint[] private votes;
    address private owner;
    string[]  private options;
    address[]  registers;
    mapping (address => bool) private hasRegistered;
    mapping (address=> bool) private hasVoted;
    mapping (string => OptionPos) private posOfOptions;

    constructor(string[] memory _options){
          owner=msg.sender;
          options=_options;
          votes=new uint[](options.length);

          for(uint i=0; i<options.length;i++){
            OptionPos memory optionPos=OptionPos(i, true);
            string memory optionName = options[i];
            posOfOptions[optionName]= optionPos;
          }
    }
    modifier onlyOwner() {
       require(owner==msg.sender, "You are not authorized to register voters");
        _;
    }
    function register(address voter) public onlyOwner{
        require(!hasRegistered[voter], "You have already registerd");
        registers.push(voter);
        hasRegistered[voter]=true;
    }

    modifier onlyRegisteredVoter() {
        require(hasRegistered[msg.sender], "Only registered members can vote");
        _;
    }


    function vote(string memory optionName) public onlyRegisteredVoter {
          require(!hasVoted[msg.sender], "Account has already voted");

          OptionPos memory optionPos=posOfOptions[optionName];
          require(optionPos.exists, "Option does not exist");

          votes[optionPos.pos]=votes[optionPos.pos] + 1;

          hasVoted[msg.sender]=true;


    }

    function getOption()public view returns (string[] memory){
        return options;
    }
    function getVotes() public view returns(uint[] memory){
        return votes;
    }

    function getRegisteredVoters() public view returns(uint){
        return registers.length;
    }

    

}