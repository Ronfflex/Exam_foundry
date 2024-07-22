## Utilisation

Remplissez les variables d'environnement suivantes :
```bash
PRIVATE_KEY=
WALLET_ADDRESS=
SEPOLIA_RPC_URL=https://rpc2.sepolia.org/
AMOY_RPC_URL=https://polygon-amoy-bor-rpc.publicnode.com
```

Pour exécuter la solution, vous aurez besoin de Foundry. Exécutez :

```bash
forge build
forge script script/Hack.s.sol
forge script script/Hack.s.sol --rpc-url $SEPOLIA_RPC_URL
forge script script/Hack.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

# Exploit Smart Contracts Using HackScript

This project demonstrates how to exploit a specific smart contract (`HackMeIfYouCan`) by using a combination of Solidity and Foundry scripting. The script performs various actions to exploit vulnerabilities and gain advantages within the contract.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Contracts](#contracts)
  - [HackMeIfYouCan](#hackmeifyoucan)
  - [Player](#player)
  - [HackScript](#hackscript)
- [Setup and Deployment](#setup-and-deployment)
- [Exploitation Steps](#exploitation-steps)
  - [Flip Function](#flip-function)
  - [Contribute Function](#contribute-function)
  - [Ether Transfer](#ether-transfer)
  - [Send Key](#send-key)
- [Running the Script](#running-the-script)
- [Conclusion](#conclusion)

## Overview

The purpose of this project is to demonstrate how an attacker can exploit various functions of a smart contract to gain control and increase their marks. The script interacts with the `HackMeIfYouCan` contract and performs the following actions:
1. Flips a virtual coin to win consecutive times.
2. Contributes funds to become the owner.
3. Sends ether to increase marks.
4. Sends a key to increase marks further.

## Prerequisites

Before running the script, ensure you have the following installed:

- Solidity compiler
- Foundry (Forge and Cast)
- Node.js and npm (for setting up the project)

## Contracts

### HackMeIfYouCan

This is the target contract with various functions that can be exploited. Key features include:
- Contribution mechanism to change ownership.
- Flip function to guess a coin flip.
- Mechanism to increase marks by sending ether and keys.

### Player

The `Player` contract acts as an intermediary to interact with the `HackMeIfYouCan` contract. It includes:
- A `flip` function to predict the outcome of a coin flip.
- An `isLastFloor` function to manipulate building floors.

### HackScript

The `HackScript` contract is a Foundry script that orchestrates the exploitation. It performs the following:
- Sets up and initializes the target and player contracts.
- Exploits the `contribute` function to become the owner.
- Calls the `flip` function through the `Player` contract.
- Sends ether to the contract to increase marks.
- Sends a key to the contract to increase marks further.

## Setup and Deployment

1. **Clone the Repository:**

    ```sh
    git clone https://github.com/Ronfflex/Exam_foundry
    ```
2. **Compile the Contracts:**

    ```sh
    forge build
    ```

3. **Deploy the Contracts:**

    Update the deployment addresses and variables in the `HackScript` contract as needed.

## Exploitation Steps

### Flip Function

The `flip` function predicts the outcome of a coin flip using block hash values and a predefined factor. The script:
1. Calls the `flip` function via the `Player` contract.
2. Predicts the correct side and logs the result.

### Contribute Function

The `contribute` function allows users to send ether to the contract and become the owner if their contribution exceeds the current owner's. The script:
1. Repeatedly calls the `contribute` function to accumulate contributions.
2. Ensures the attacker becomes the new owner.

### Ether Transfer

The script sends ether to the contract to trigger the `receive` function and increase marks. It:
1. Calls the `contribute` function with a small amount of ether.
2. Sends additional ether directly to the contract.

### Send Key

The script sends a key to the contract to trigger the `sendKey` function and increase marks. It:
1. Loads a specific data value from the contract's storage.
2. Calls the `sendKey` function with the extracted key.

## Running the Script

To execute the exploit script, run the following command:

```sh
forge script script/Hack.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

Replace `<your-private-key>` with the private key of the attacker's account.
