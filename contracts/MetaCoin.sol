pragma solidity >=0.5.0 <0.6.0;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
	mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // 1. let's define an owner
    // 2. set owner in the constructor
    // 3. create a "protected" setOwner function -- only owner can call it
    // 4. create a "protected" setConvertionRatio(uint256 _newRatio) function
    // 5. create a moveCoins(_from, _to, _amount) function
    //    -- the goal is that owner can move someone elses coins
    // 6. create an *internal* function _transfer(_from, _to, _amount)
    //    -- this is a helper function to be used in moveCoins and sendCoin
    // 7. Understand the differance between tx.origing and msg.sender

	constructor() public {
		balances[tx.origin] = 10000;
	}

	function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		emit Transfer(msg.sender, receiver, amount);
		return true;
	}

	function getBalanceInEth(address addr) public view returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}

	function getBalance(address addr) public view returns(uint) {
		return balances[addr];
	}
}
