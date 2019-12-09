pragma solidity ^0.5.0;

import "./token/ERC20/IERC20.sol";

/**
 * Atomic Swap with Escrow account
 *
 * Steps to use Escrow account using executeOrder flow:
   1. party1 registers the order
   2. party1 creates allowance for Escrow
   3. party2 creates allowance for Escrow
   4. party2 call executeOrder
 *
 * Steps to use onTokenTransfer
   1. party1 or party 2 registers an order
   2. party1 transfers tokens to Escrow assuming a token supports callback
   3. party2 transfers tokens to Escrow assumint a token supports callback
 */
contract Escrow {

    mapping (uint256 => Order) orders;

    struct Order {
        address party1;
        IERC20 coin1;
        uint256 amount1;
        address party2;
        IERC20 coin2;
        uint256 amount2;

        // this is used by onTokenTransferVersion
        bool party1Done;
        bool party2Done;
    }
    uint256 private nextOrder = 0;


    function registerOrder(address recipient,
            IERC20 coin1,
            uint256 amount1,
            IERC20 coin2,
            uint256 amount2) public returns(uint256) {
        nextOrder++;
        orders[nextOrder] = Order(msg.sender, coin1, amount1, recipient, coin2, amount2, false, false);
    }

    // onTokenTransfer is a callback by token transfer function
    // NOTE: unfortunately this function will never be executed as a callback on ERC20 tokens
    //   because of limitaitons of ERC20.
    function onTokenTransfer(address from, uint256 amount, bytes calldata data) external {
        uint256 orderID = sliceUint(data, 0);
        Order storage o = orders[orderID];
        if (o.party1 == from ) {
            require(o.amount1 == amount);
            if (o.party2Done) {
                o.coin1.transfer(o.party2, o.amount1);
                o.coin2.transfer(o.party1, o.amount2);
                delete orders[orderID];
            } else {
                o.party1Done = true;
            }
        } else if (o.party2 == from) {
            // TODO ....
        } else {
            revert("Wrong orderID");
        }
    }

    // executeOrder is a funciton to work around the ERC20 limitations and execute order based on allowances.
    // This funcion succeeds only if Escrow has active allowances on coin1 and coin2 repectively for party1 and party2.
    function executeOrder(uint256 orderID, IERC20 coin1, uint256 amount1, IERC20 coin2, uint256 amount2) public {
        Order storage o = orders[orderID];
        // TODO: verify o paremeters (o.coin1 == coin1 ....)
        require(coin1.transferFrom(o.party1, o.party2, amount1));
        require(coin2.transferFrom(o.party2, o.party1, amount2));
        delete orders[orderID];
    }

    // extracts an uint from bytes data
    function sliceUint(bytes memory data, uint start) internal pure returns (uint) {
        require(data.length >= start + 32, "slicing out of range");
        uint x;
        assembly {
            x := mload(add(data, add(0x20, start)))
        }
        return x;
    }
}
