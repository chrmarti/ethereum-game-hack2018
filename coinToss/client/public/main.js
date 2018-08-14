window.addEventListener('load', function () {
    if (typeof web3 === 'undefined') {
        log('web3 not defined. Install MetaMask browser extension?');
        return;
    }

    var CoinTossContract = web3.eth.contract([{ "constant": false, "inputs": [{ "name": "myid", "type": "bytes32" }, { "name": "result", "type": "string" }], "name": "__callback", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [{ "name": "_queryId", "type": "bytes32" }, { "name": "_result", "type": "string" }, { "name": "_proof", "type": "bytes" }], "name": "__callback", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [], "name": "recharge", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": false, "inputs": [{ "name": "betHead", "type": "bool" }], "name": "play", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "inputs": [], "payable": true, "stateMutability": "payable", "type": "constructor" }, { "anonymous": false, "inputs": [{ "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "betHead", "type": "bool" }, { "indexed": false, "name": "betValue", "type": "uint256" }, { "indexed": false, "name": "outcome", "type": "uint8" }], "name": "GameEnd", "type": "event" }]);
    var CoinToss = CoinTossContract.at('0x2dfa5cba4f3b738264b21a5748bb9d58c12e82fb');
    var Outcomes = ['win', 'loss', 'house'];
    var wei = 1000000000000000000;

    CoinToss.GameEnd(function (err, res) {
        if (err) {
            console.error(err);
        }
        console.log(res);
        log(err || ('Outcome: ' + Outcomes[web3.toDecimal(res.args.outcome)] + ', bet: ' + (web3.toDecimal(res.args.betValue) / wei) + ', head: ' + res.args.betHead + ', player: ' + res.args.player));
    });

    document.querySelector('#heads')
        .addEventListener('click', play.bind(void 0, true));

    document.querySelector('#tails')
        .addEventListener('click', play.bind(void 0, false));

    function play(betHead) {
        var betValue = parseFloat(document.querySelector('#betValue').value);
        CoinToss.play(betHead, { value: betValue * wei }, function (err, res) {
            if (err) {
                console.error(err);
            }
            log(err || ('Play tx: ' + res));
        });
    }

    function log(obj) {
        var ul = document.querySelector('#log ul');
        var li = document.createElement('li');
        li.textContent = String(obj);
        ul.appendChild(li);
    }
});