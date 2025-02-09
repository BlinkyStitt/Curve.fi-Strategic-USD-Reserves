// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ICurveStableSwapNG, IERC20, IVault, ZapStrategicReserves} from "../src/ZapStrategicReserves.sol";

contract ZapStrategicReservesTest is Test {

    uint256 public mainnetFork;
    IERC20 public usdc;
    IERC20 public usdt;
    ICurveStableSwapNG public exchange;
    IVault public vault;
    address public donations;

    ZapStrategicReserves public zap;

    function setUp() public {
        string memory MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        vm.selectFork(mainnetFork);

        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        exchange = ICurveStableSwapNG(0x4f493B7dE8aAC7d55F71853688b1F7C8F0243C85);
        vault = IVault(0xfBd4d8bf19c67582168059332c46567563d0d75f);
        donations = makeAddr("donations");    

        zap = new ZapStrategicReserves(usdc, usdt, exchange, vault, donations);
    }

    function test_usdcToBest(uint256 amount) public {
        vm.assume(amount > 0);
        // TODO: use usdc.decimals for this?
        vm.assume(amount <= 1_000_000 * 1e6);
        console.log("usdc", amount);

        deal(address(usdc), address(this), amount);

        usdc.approve(address(zap), amount);

        uint256 shares = zap.deposit(amount, 0, address(this));

        console.log("shares", shares);

        // TODO: make sure approval is 0 now?

        vault.approve(address(zap), shares);

        (uint256 heavy_id, uint256 received) = zap.withdrawBest(shares, address(this));

        console.log("heavy_id", heavy_id);
        console.log("received", received);

        assert (received >= amount * 999 / 1000);

        // TODO: make sure approval is 0 now?


    }
}

