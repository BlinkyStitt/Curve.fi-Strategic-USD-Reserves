// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ICurveStableSwapNG, IERC20, IVault, ZapStrategicReserves} from "../src/ZapStrategicReserves.sol";

contract ZapStrategicReservesScript is Script {
    IERC20 public usdc;
    IERC20 public usdt;
    ICurveStableSwapNG public exchange;
    IVault public vault;
    address public donations;

    ZapStrategicReserves public zap;

    function setUp() public {}

    function run() public {
        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        exchange = ICurveStableSwapNG(0x4f493B7dE8aAC7d55F71853688b1F7C8F0243C85);
        vault = IVault(0xfBd4d8bf19c67582168059332c46567563d0d75f);
        donations = 0x2699C32A793D58691419A054DA69414dF186b181;

        // TODO: read private key from env and use that to broadcast
        vm.startBroadcast();

        zap = new ZapStrategicReserves(usdc, usdt, exchange, vault, donations);

        // TODO: transfer 1 wei of usdc/usdt/exchange to the contract to save some gas
        // vault tokens don't get transfered here so they don't need to be transferred

        vm.stopBroadcast();
    }
}
