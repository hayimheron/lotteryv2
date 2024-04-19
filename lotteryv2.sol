// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {

    address public owner;
    address payable[] public players;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        require(msg.value >= 500 wei, "You cannot participate with a balance lower than 500");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) {

        require(msg.sender == owner, "You are not the owner of the lottery");
        return address(this).balance;

    }

    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function announceWinner() public {
        require(msg.sender == owner, "You are not the owner");
        require(players.length >= 3, "Must be 3 or more players");
        address payable winner;
        uint callRandom = random();
        uint index = callRandom % players.length;
        winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0);

    }
    
}
