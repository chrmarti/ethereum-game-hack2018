pragma solidity ^0.4.22;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract coinToss is usingOraclize {
    
    enum Outcome { WIN, LOSS, HOUSE }
    
    event GameEnd(
        address player,
        bool betHead,
        uint256 betValue,
        Outcome outcome
    );

    struct GameData {
        address player;
        bool betHead;
        uint256 betValue;
        bool inUse;
    }

    mapping(bytes32 => GameData) games;
    
    constructor() public payable {
        oraclize_setProof(proofType_Ledger);
    }
    
    function play(bool betHead) public payable {
        require(msg.value <= address(this).balance / 2, "At most half of contract's balance allowed.");
        GameData storage game = games[newRandomQuery()];
        assert(!game.inUse);
        game.player = msg.sender;
        game.betHead = betHead;
        game.betValue = msg.value;
        game.inUse = true;
    }
    
    function __callback(bytes32 _queryId, string _result, bytes _proof) public { 
        assert(msg.sender == oraclize_cbAddress());
        GameData storage game = games[_queryId];
        assert(game.inUse);
        game.inUse = false;
        
        if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0) {
            uint r = uint(keccak256(bytes(_result))) % 100;
            
            if (r == 49 || r == 50) {
                emit GameEnd(game.player, game.betHead, game.betValue, Outcome.HOUSE);
            } else {
                bool head = r > 50;
                if (game.betHead == head) {
                    game.player.transfer(game.betValue * 2);
                    emit GameEnd(game.player, game.betHead, game.betValue, Outcome.WIN);
                } else {
                    emit GameEnd(game.player, game.betHead, game.betValue, Outcome.LOSS);
                }
            }
        }
    }
    
    function newRandomQuery() private returns (bytes32) {
        uint N = 7; // number of random bytes
        uint delay = 0; // number of seconds
        uint callbackGas = 200000; // gas for the callback function
        return oraclize_newRandomDSQuery(delay, N, callbackGas);
    }
    
    function recharge() public payable {
    }
}