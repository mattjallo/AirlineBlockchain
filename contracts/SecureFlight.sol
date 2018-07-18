pragma solidity ^0.4.17;

import "./PassengerVetting.sol";

contract SecureFlightProfile is PassengerVetting {
  //first name, middle name, last name, gender, birthdate
  struct sfProfileStruct {
    bytes32 firstName;
    bytes32 middleName;
    bytes32 lastName;
    bytes2 gender;
    bytes18 birthDate;
    bytes32 knownTravelerNumber;
    bytes26 redressNumber;
  }
  mapping (address => sfProfileStruct) public sfProfiles;
}



