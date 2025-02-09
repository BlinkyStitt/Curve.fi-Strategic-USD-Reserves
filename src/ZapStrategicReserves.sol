// SPDX-License-Identifier: UNLICENSED
//
// A "zap" for Curve's strategic USD reserves.
// "Concentrated Liquidity" without painful impermant loss? Maybe.
// Generally, its bad to treat an exchange pool as being redeemable 1:1. But this pool has a huge "A" and so even if its very overweight on one side, its still tradeable at an okay rate.
// this is only safe because both usdc and usdt are redeemable 1:1 for USD. If the pool was overweight on a non-redeemable token, it would be a disaster.
pragma solidity ^0.8.13;

// TODO: import ERC20 and ICurveExchange and yearn's vault standard

contract ZapStrategicReserves {
    address public immutable usdc;
    uint256 public immutable usdc_id;
    address public immutable usdt;
    uint256 public immutable usdt_id;
    address public immutable exchange;
    address public immutable vault;
    address public immutable donations;

    constructor(address _usdc, address _usdt, address _exchange, address _vault, address _donations) {
        usdc = _usdc;
        usdt = _usdt;
        exchange = _exchange;
        vault = _vault;
        donations = _donations;

        // TODO: safety check for coin numbers matching what we expect
        usdc_id = ???;
        usdt_id = ???;

        // TODO: safety check that the vault matches the exchange. or maybe exchange should be fetched from the vault here?

        _usdc.approve(exchange, type(uint256).max);
        _usdt.approve(exchange, type(uint256).max);
        _exchange.approve(vault, type(uint256).max);
    }

    // TODO: doing approvals correctly is hard. just make it work for msg.sender everywhere first
    function deposit(address to, uint256 usdc_amount, uint256 usdt_amount) public returns (uint256 vault_amount) {
       // TODO: actually. can we transfer it to the exchange and then call some sort of method that mints based on the amounts we sent?

        if (c_amount) {
            _usdc.transferFrom(msg.sender, donations, c_amount);
        }
        if (t_amount) {
            _usdt.transferFrom(msg.sender, donations, t_amount);
        }

        revert("not implemented");
    }

    // TODO: vyper's default arguments would be really nice
    function depositUSDC(uint256 usdc_amount) public returns (uint256 vault_amount){
        vault_amount = _deposit(amount, 0);
    }

    function depositUSDT(uint256 usdt_amount) public returns (uint256 vault_amount) {
        vault_amount = _deposit(0, amount);
    }

    function redeemBest(uint256 lp_amount) {
        revert("not implemented");
    }

    function redeemUSDC(uint256 lp_amount) {
        revert("not implemented");
    }

    function redeemUSDT(uint256 lp_amount) {
        revert("not implemented");
    }

    function withdrawBest(uint256 amount) public returns (uint256 vault_amount){
        revert("not implemented");
    }

    function withdrawUSDC(uint256 c_amount) public returns (uint256 vault_amount) {

    function withdrawUSDT(uint256 t_amount) public returns (uint256 vault_amount) {
        // TODO: calculate how much LP tokens we need to withdraw to get this amount of USDT
        // TODO: calculate how many vault tokens we need to withdraw to get this amount of LP tokens
        // TODO: do the withdrawal
        // TODO: transfer the USDT to the user
        revert("not implemented");
    }

    function donate(uint256 c_amount, uint256 t_amount, uint256 lp_amount, uint256 vault_amount) public {


        revert("not implemented");
    }
}
