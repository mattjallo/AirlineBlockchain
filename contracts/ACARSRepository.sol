pragma solidity ^0.4.17;

contract ACARSMessage {
    uint public messageTime; 
    uint public channel;
    bytes9 public idStr;
    uint public err;
    uint public lvl;
    byte public mode;
    bytes8 public aircraftRegistration;
    byte public ack;
    bytes3 public label;
    byte public bid;
    bytes5 public numberStr;
    bytes5 public flightIdStr;
    string public messageText;

    constructor(uint _messageTime, uint _channel, bytes9 _idStr, uint _err, uint _lvl, byte _mode, bytes8 _aircraftRegistration, byte _ack, bytes3 _label, byte _bid, bytes5 _numberStr, bytes5 _flightIdStr, string _messageText) public {
      messageTime = _messageTime;
      channel = _channel;
      idStr = _idStr;
      err = _err;
      lvl = _lvl;
      mode = _mode;
      aircraftRegistration = _aircraftRegistration;
      ack = _ack;
      label = _label;
      bid = _bid;
      numberStr = _numberStr;
      flightIdStr = _flightIdStr;
      messageText = _messageText;
    }
}

contract ACARSGroundStation {
  bytes32 public stationName;
  bytes32 public stationLocation;
  address internal stationOwner;
  address[] internal acarsAuthorities;

  mapping (address => bool) public acarsMessages;

  constructor(bytes32 _stationName, bytes32 _stationLocation) public {
    stationName = _stationName;
    stationLocation = _stationLocation;
    stationOwner = msg.sender;
  }

  function AddACARSAuthority(address acarsAuthority) public {
    acarsAuthorities.push(acarsAuthority);
  }

  modifier onlyStationOwner() {
    require(msg.sender==stationOwner);
    _;
  }

  function TransferStationOwner(address newOwner) onlyStationOwner public {
    stationOwner = newOwner;
  }

  function PublishACARSMessage(uint messageTime, uint channel, bytes9 idStr, uint err, uint lvl, byte mode, bytes8 aircraftRegistration, byte ack, bytes3 label, byte bid, bytes5 numberStr, bytes5 flightIdStr, string messageText) onlyStationOwner public {
    address newAcarsMessage = new ACARSMessage(messageTime, channel, idStr, err, lvl, mode, aircraftRegistration, ack, label, bid, numberStr, flightIdStr, messageText);
    acarsMessages[newAcarsMessage] = true;
    for(uint i=0; i<acarsAuthorities.length; i++) {
      ACARSAuthority authority = ACARSAuthority(acarsAuthorities[i]);
      authority.BroadcastACARSMessage(newAcarsMessage);
    }
  }

  function VerifyACARSMessage(address acarsMessage) public returns (bool) {
    return acarsMessages[acarsMessage];
  }
}

contract ACARSAuthority {
  address internal authorityOwner;
  bytes32 public authorityName;

  mapping (address => bool) internal syndicatedGroundStations;
  mapping (address => bool) public auditedAcarsMessages;
  mapping (uint => address) public auditedAcarsMessagesIndex;
  uint public auditedAcarsMessagesCount = 0;

  constructor(bytes32 _authorityName) public {
    authorityOwner = msg.sender;
    authorityName = _authorityName;
  }

  modifier onlySyndicatedStations() {
    require( syndicatedGroundStations[msg.sender] );
    _;
  }

  modifier onlyAuthorityOwner() {
    require(msg.sender == authorityOwner);
    _;
  }

  function changeAuthorityOwner() onlyAuthorityOwner public {
    authorityOwner = msg.sender;
  }

  event ReceivedACARSMessage(address acarsMessage);

  //Syndicate a ground station as part of the trusted network
  function AuthorizeGroundStation(address groundStation) onlyAuthorityOwner public {
    syndicatedGroundStations[groundStation] = true;
  }

  //Listen for ACARS Message Publishing events from a trusted ground station
  //Messages broadcast from syndicated stations are implicitly approved
  function BroadcastACARSMessage(address acarsMessage) onlySyndicatedStations public {
    auditedAcarsMessages[acarsMessage] = true;
    auditedAcarsMessagesIndex[auditedAcarsMessagesCount] = acarsMessage;
    auditedAcarsMessagesCount++;
    emit ReceivedACARSMessage(acarsMessage);
  }

  function AuditApproveMessage(address acarsMessage) onlyAuthorityOwner public {
    if(!auditedAcarsMessages[acarsMessage]) {
      auditedAcarsMessages[acarsMessage] = true;
      auditedAcarsMessagesIndex[auditedAcarsMessagesCount] = acarsMessage;
      auditedAcarsMessagesCount++;
      emit ReceivedACARSMessage(acarsMessage);
    } 
  }

  function AuditRejectMessage(address acarsMessage) onlyAuthorityOwner public {
    auditedAcarsMessages[acarsMessage] = false;
  }
}
