pragma solidity >=0.5.0 <0.6.0;

import "../ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
    mapping (address => uint256) balances;
    address public owner;
    uint256 public convertionRatio = 2;

    event Transfer(address indexed from, address indexed to, uint256 value);

    // 1. let's define an owner
    // 2. set owner in the constructor
    // 3. create a "protected" setOwner function -- only owner can call it
    // 4. create a "protected" setConvertionRatio(uint256 _newRatio) function
    // 5. create a moveCoins(_from, _to, _amount) function
    //    -- the goal is that owner can move someone elses coins
    // 6. create an *internal* function _transfer(_from, _to, _amount)
    //    -- this is a helper function to be used in moveCoins and sendCoin
    // 7. Understand the differance between tx.origing and msg.sender

    constructor(address _owner) public {
        owner = _owner;
        balances[tx.origin] = 10000;
    }

    function setOwner(address _newOwner) public {
        require (msg.sender == owner, "E001");
        owner = _newOwner;
    }

    function setConvertionRatio(uint256 _newRatio) public {
        require (msg.sender == owner);
        convertionRatio = _newRatio;
    }

    function _transfer(address _from, address _to, uint256 _amount) internal {
        require(balances[_from] >= _amount);
        balances[_to] += _amount;
        balances[_from] -= _amount;
        emit Transfer(_from, _to, _amount);
    }

    function moveCoins(address _from, address _to, uint256 _amount) external {
        require (msg.sender == owner);
        _transfer(_from, _to, _amount);
    }


    function sendCoin(address receiver, uint256 amount) public returns(bool) {
        _transfer(msg.sender, receiver, amount);
        return true;
    }

    function getBalanceInEth(address addr) public view returns(uint256){
        return ConvertLib.convert(getBalance(addr), convertionRatio);
    }

    function getBalance(address addr) public view returns(uint256) {
        return balances[addr];
    }
}
