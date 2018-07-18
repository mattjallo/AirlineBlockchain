//var ACARSMessage = olrtifacts.require("ACARSMessage");
var ACARSGroundStation = artifacts.require("ACARSGroundStation");
var ACARSAuthority = artifacts.require("ACARSAuthority");

var gsInstance, aaInstance;

module.exports = function(deployer) {
  //deployer.deploy(ACARSMessage);
  deployer.deploy(ACARSGroundStation, "Ground Station Prototype 1", "Phoenix, AZ");
  deployer.deploy(ACARSAuthority, "Federal Aviation Administration").then(function() {
    ACARSAuthority.deployed().then(function(instance) {
      instance.AuthorizeGroundStation(ACARSGroundStation.address);
      console.log("Syndicated Ground Station Prototype 1");
    });
  });
}
