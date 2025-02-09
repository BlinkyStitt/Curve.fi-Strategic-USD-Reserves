// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ICurveStableSwapNG, IERC20, IVault, SafeERC20, ZapStrategicReserves} from "../src/ZapStrategicReserves.sol";

contract ZapStrategicReservesTest is Test {
    using SafeERC20 for IERC20;

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

    function test_depositToBest(uint256 usdc_amount, uint256 usdt_amount) public {
        // TODO: use usdc.decimals for this?
        vm.assume(usdc_amount / 1e6 <= 100_000);
        vm.assume(usdt_amount / 1e18 <= 100_000);
        // TODO: we should have a test that tests for tiny amounts. but let's ignore <$1 for now
        vm.assume(usdc_amount == 0 || usdc_amount / 1e6 > 0);
        vm.assume(usdt_amount == 0 || usdt_amount / 1e18 > 0);
        console.log("usdc", usdc_amount);
        console.log("usdt", usdt_amount);

        deal(address(usdc), address(this), usdc_amount);
        deal(address(usdt), address(this), usdt_amount);

        // setup approvals for depositing
        usdc.approve(address(zap), usdc_amount);
        usdt.forceApprove(address(zap), usdt_amount);

        uint256 shares = zap.deposit(usdc_amount, usdt_amount, address(this));
        console.log("vault shares", shares);

        require(shares > 0, "no shares");
        require(shares == vault.balanceOf(address(this)), "unexpected share balance");
        require(
            usdc.allowance(address(this), address(zap)) == 0, "unexpected usdc allowance. it should have all been used"
        );
        require(
            usdt.allowance(address(this), address(zap)) == 0, "unexpected usdt allowance. it should have all been used"
        );

        // setup approvals for withdrawing
        vault.approve(address(zap), shares);

        // TODO: test withdraw since people will probably want to think in terms of the underlying and not shares
        (uint256 heavy_id, uint256 received) = zap.redeemBest(shares, address(this));

        console.log("heavy_id", heavy_id);
        console.log("received", received);

        uint256 deposited_amount = usdt_amount + usdc_amount;
        uint256 max_slippage = deposited_amount * 999 / 1000;

        require(received >= max_slippage, "bad slippage");

        // TODO: make sure approval is 0 now?
    }
}
