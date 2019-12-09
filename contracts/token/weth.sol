pragma solidity ^0.5.12;

import "./CASToken.sol";


// This is a wrapped ETH into a ERC20 token
contract wETH is CASToken {
    string public name  = "etherc20";
    uint8 public decimals = 18;

    event  Withdrawal(address indexed src, uint wad);

    function () external payable {
        _mint(msg.sender, msg.value);
    }

    function withdraw(address payable recipient, uint wad) public {
        require(_balances[msg.sender] >= wad);
        _balances[msg.sender] -= wad;
        recipient.transfer(wad);
        emit Withdrawal(recipient, wad);
    }
}
