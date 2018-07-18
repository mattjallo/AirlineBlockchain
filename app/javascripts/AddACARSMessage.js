// Import libraries we need.
//import { default as Web3} from 'web3';
//import { default as contract } from 'truffle-contract'
const web3 = require("web3");
const contract = require("truffle-contract");

// Import our contract artifacts and turn them into usable abstractions.
//import acarsgroundstation_artifacts from '../../build/contracts/ACARSGroundStation.json'
const acarsgroundstation_artifacts = require('../../build/contracts/ACARSGroundStation.json');

// ACARSGroundStation is our usable abstraction, which we'll use through the code below.
var ACARSGroundStation = contract(acarsgroundstation_artifacts);

// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;

ACARSGroundStation.setProvider(web3.currentProvider);
web3.eth.getAccounts(function(err, accs) {
  if(err != null) {
    console.log("There was an error fetching your accounts.");
    return;
  }
  if(accs.length == 0) {
    console.log("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
    return;
  }
  accounts = accs;
  account = accounts[0];

  //self.refreshBalance();
});

var ts = Math.round((new Date()).getTime() / 1000);

ACARSGroundStation.deployed().then(function(instance) {
  instance.PublishACARSMessage(ts, 2, "ID101", 0, 1, "M", "NT1001", "A", "LAB", "B", "NO101", "FL101", "Test ACARS Message Text");
});

