pragma solidity >=0.5.0 <0.6.0;

contract KillMe {
    function () external payable {}

    event Result(uint8 result);

    function add(uint8 a, uint8 b) public  {
        uint8 result = a+b;
        // add require ;)
        // to see the result we need to emit it. Return doesn't work.
        emit Result(result+1);
    }

    function finish(address payable _dest) public {
        selfdestruct(_dest);
    }
}
