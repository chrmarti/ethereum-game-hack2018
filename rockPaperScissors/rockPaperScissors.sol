pragma solidity ^0.4.16;

contract rockpaperscissors {
    enum Move { ROCK, PAPER, SCISSORS }
    
    uint wager;
    uint constant INCENTIVE = 4;
    
    address player1;
    bytes32 hmac;
    string nonce;
    Move move1;

    address player2;
    Move move2;
    
    uint time1;
    uint time2;

    event Outcome (
        address winner,
        Move move,
        uint wager
    );
    
    // Round 1: player 1's bet; only store hash, to be uncovered later
    constructor(bytes32 hiddenMove) public payable {
        require(msg.value % INCENTIVE == 0);
        player1 = msg.sender;
        hmac = hiddenMove;
        wager = msg.value / INCENTIVE;
        time1 = now;
    }
    
    // Round 2: player 2's move
    function counterbet(Move move) public payable {
        require(player2 == 0x00); // player 2 has not played yet
        require(msg.value == wager * INCENTIVE);
        move2 = move;
        player2 = msg.sender;
        time2 = now;
    }
    
    // Round 3: player 1 discloses their move
    function reveal(Move move, string secret) public {
        require(msg.sender == player1);
        require(player2 != 0x00); // player 2 has moved
        require(address(this).balance > 0); // not payed out yet
        bytes32 verify = hash(move, secret);
        require(verify == hmac);
        
        move1 = move;
        nonce = secret;
        
        int w = win(move1, move2);
        payout(w);
        announceWinner(w);
    }
    
    // No player 2 joins within a day
    function reclaim() public {
        require(msg.sender == player1);
        require(now >= time1 + 1 days);
        require(player2 == 0x00);   // player 2 hasn't joined
        player1.transfer(address(this).balance);
    }
    
    // Player 1 refuses to reveal their move
    function forfeit() public {
        require(msg.sender == player2); // player 2 has joined
        require(now >= time2 + 1 days);
        player2.transfer(address(this).balance); // 0 if called after reveal
    }
    
    function incentive() pure public returns (uint) {
        return INCENTIVE;
    }
    
    //  1: player 1 wins
    // -1: player 2 wins
    //  0: draw
    function win(Move m1, Move m2) pure public returns (int) {
        return int((uint(m1) - uint(m2) + 4) % 3) - 1;
    }

    function announceWinner(int w) private {
        if (w == 0) {
            emit Outcome(0x00, move1, wager);
        } else if (w == 1) {
            emit Outcome(player1, move1, wager);
        } else {
            emit Outcome(player2, move2, wager);
        }
    }
    
    function payout(int w) private {
        player1.transfer(wager * uint(int(INCENTIVE) + w));
        player2.transfer(wager * uint(int(INCENTIVE) - w));
        assert(address(this).balance == 0);
    }
    
    function hash(Move move, string secret) pure public returns (bytes32) {
        return keccak256(abi.encodePacked(secret, uint8(move)));
    }
}