if (typeof web3 !== 'undefined') {
   web3 = new Web3(web3.currentProvider);
} else {
   web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

web3.eth.defaultAccount = web3.eth.accounts[0];

var CoursetroContract = web3.eth.contract(YOUR ABI);

var CoinToss = CoursetroContract.at('CONTRACT ADDRESS');

CoinToss.getInstructor(function(error, result) {
   if (!error) {
       $("#instructor").html(result[0]+' ('+result[1]+' years old)');
   } else
        console.log(error);
});

$("#button").click(function() {
   $("#loader").show();
   CoinToss.setInstructor($("#name").val(), $("#age").val());
});
