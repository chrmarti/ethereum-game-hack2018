pragma solidity ^0.4.22;

contract coinToss {

    constructor() public payable {
        // just that
    }

    function play(bool betHead) public payable returns (string) {
        require(msg.value <= address(this).balance / 2, "At most half of contract's balance allowed.");
        uint8 r = random();
        if (r == 49 || r == 50) {
            return "Edge! You loose!";
        }
        bool head = r > 50;
        if (betHead == head) {
            msg.sender.transfer(msg.value * 2);
            return "You win!";
        }
        return "You loose!";
    }
    
    function random() private view returns (uint8) {
        // Not safe.
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%100);
    }
}