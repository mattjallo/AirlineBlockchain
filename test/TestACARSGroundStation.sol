pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ACARSRepository.sol";

contract TestACARSGroundStation {
  ACARSGroundStation groundStation = ACARSGroundStation(DeployedAddresses.ACARSGroundStation());

  function testACARSMessageCreation() public {
    groundStation.PublishACARSMessage(now, 2, "ID101", 0, 1, "M", "NT1001", "A", "LAB", "B", "NO101", "FL101", "Test ACARS Message Text");
  }
}
