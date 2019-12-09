pragma solidity ^0.5.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library BitRoles {
    uint32 constant MINTTER = 1;
    uint32 constant OWNER = 2;
    uint32 constant BURNER = 4;
    uint32 constant MANAGER = 8;

    function hasRole(mapping(address => uint) storage roles, address who, uint role) public view returns(bool) {
        uint x = roles[who];
        if (x==0) return false;

        return x & role > 0;
    }

    // TODO: add functions for adding and removing roles
}
