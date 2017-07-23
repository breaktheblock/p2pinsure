// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import p2pinsure_artifacts from '../../build/contracts/P2pinsure.json'

// MetaCoin is our usable abstraction, which we'll use through the code below.
var P2pInsure = contract(p2pinsure_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;

window.App = {
  start: function() {
    var self = this;


    // Bootstrap the MetaCoin abstraction for Use.
    P2pInsure.setProvider(web3.currentProvider);

    $("#adjudicatorArea").hide();
    $("#resolution").on("change", function() {
        if(this.value === "adjudicator"){
            $("#adjudicatorArea").show();
        } else if(this.value === "voting"){
            $("#adjudicatorArea").hide();
        } else if(this.value === "oracle"){
            $("#adjudicatorArea").hide();
        }
    });



    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0];

       var accountsHtml = "";

        accountsHtml = accountsHtml + "<option value='0'>Adjudicator</option>";
        accountsHtml = accountsHtml + "<option value='1'>Creator</option>";
        accountsHtml = accountsHtml + "<option value='2'>Friend #1</option>";
        accountsHtml = accountsHtml + "<option value='3'>Friend #2</option>";


      for(var i = 3; i<accounts.length; i++){
        accountsHtml = accountsHtml + "<option value='" + i + "'>" + i +"</option>"
      }

      $("#accounts").html(accountsHtml);
      $("#accounts").on("change", function() {
                      account = accounts[this.value]
                                        });
    });
  },

  setStatus: function(message) {
    var status = document.getElementById("status");
    status.innerHTML = message;
  },

  setAccount: function(accountNo) {
    account = accounts[accountNo];
  },

  createPolicy: function(){
    var self = this;
    var p2p;
    var adjudicator = $('#adjudicator').val();
    var name = $('#policyName').val();
    var votingOpt = $('#resolution').find(":selected").text();
    var voting = false;
    if  (votingOpt === "voting")
        voting = true;

    var maxPoolSize = $('#maxPoolSize').val();

    var joiningCriteria = $('#joiningCriteria').find(":selected").text();

    //     function create(address _adjudicator, bool _voting) {
    P2pInsure.deployed().then(function(instance) {
      p2p = instance;
      return p2p.create(adjudicator, voting, name, {from: account});
    }).then(function() {
      self.setStatus("Contract created!");
    });
  }
};

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  }

  App.start();
});
