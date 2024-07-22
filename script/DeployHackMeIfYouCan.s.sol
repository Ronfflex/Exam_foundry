// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.0;

import "forge-std/Script.sol";
import "../src/HackMeIfYouCan.sol";

contract DeployHackMeIfYouCan is Script {
    bytes32 private constant PASSWORD = keccak256("secret");
    bytes32[15] private data;

    function setUp() public {
        for (uint256 i = 0; i < 15; i++) {
            data[i] = PASSWORD;
        }
    }

    function run() public {
        vm.startBroadcast();
        HackMeIfYouCan hackMe = new HackMeIfYouCan(PASSWORD, data);
        console.log("HackMeIfYouCan deployed at:", address(hackMe));
        vm.stopBroadcast();
    }
}
