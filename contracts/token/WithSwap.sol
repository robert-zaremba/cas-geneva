pragma solidity ^0.5.0;

import "./ERC20/IERC20.sol";

interface WithSwap {
    function record_commitment(address recipient, uint256 amount, bytes32 commitment) external;
    function swap(address recipient, uint256 amountEx, uint256 amount, uint256 secret, IERC20 coin) external;
}
