//Airline Miles Token, proof of concept
//Matt Jallo (matthew.jallo@aa.com) 

pragma solidity ^0.4.17;

// AirlineMilesToken adheres to the ERC 20 Token standard
// https://github.com/ethereum/EIPs/issues/20
contract AirlineMilesToken {

    address public issuer; //may control issuance of tokens 

    uint256 public totalSupply;
    uint256 constant MAX_UINT256 = 2**256 - 1;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    
    string public name = 'Airline Miles Token';                 
    uint8 public decimals;                
    string public symbol = "AIR";                 
    string public version = 'AT0.1'; 

    function issued() {
      issuer = msg.sender;
    }

    modifier onlyIssuer() {
      require(msg.sender==issuer);
      _;
    }

    function transferIssuer(address newIssuer) onlyIssuer {
      issuer = newIssuer;
    }

    function AirlineMilesToken(
        uint256 _initialAmount,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol
        ) {
          issuer = msg.sender;
          balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
          totalSupply = _initialAmount;                        // Update total supply
          name = _tokenName;                                   // Set the name for display purposes
          decimals = _decimalUnits;                            // Amount of decimals for display purposes
          symbol = _tokenSymbol;                               // Set the symbol for display purposes
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }
    
    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
        return true;
    }

    function issueTokens(address target, uint256 amountIssued) onlyIssuer {
        balances[target] += amountIssued;
        totalSupply += amountIssued;
        Transfer(0, issuer, amountIssued);
        Transfer(issuer, target, amountIssued);
    }
}
