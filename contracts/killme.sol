pragma solidity >=0.5.0 <0.6.0;

contract KillMe {
    function finish(address payable _dest) public {
        selfdestruct(_dest);
    }
}
