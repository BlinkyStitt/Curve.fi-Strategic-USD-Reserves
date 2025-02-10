// SPDX-License-Identifier: UNLICENSED
//
// A "zap" for Curve.fi's Strategic USD reserves.
// "Concentrated Liquidity" without painful impermant loss? Maybe.
// Generally, its bad to treat an exchange pool as being redeemable 1:1.
// But this pool has a huge "A" and so even if its very overweight on one side, its still tradeable at an okay rate.
// This is only safe because both usdc and usdt are redeemable 1:1 for USD.
// If the pool was overweight on a non-redeemable token, it would be a disaster.
pragma solidity ^0.8.13;

import {IVault} from "src/interfaces/IVault.sol";
import {ICurveStableSwapNG} from "src/interfaces/ICurveStableSwapNG.sol";
import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@forge-std/console.sol";

contract ZapStrategicReserves {
    using SafeERC20 for IERC20;

    IERC20 public immutable usdc;
    uint256 public immutable usdc_id;
    IERC20 public immutable usdt;
    uint256 public immutable usdt_id;
    ICurveStableSwapNG public immutable exchange;
    IVault public immutable vault;
    address public immutable donations;
    uint256 public immutable max_coins;

    constructor(IERC20 _usdc, IERC20 _usdt, ICurveStableSwapNG _exchange, IVault _vault, address _donations) {
        usdc = _usdc;
        usdt = _usdt;
        exchange = _exchange;
        vault = _vault;
        donations = _donations;

        usdc_id = 0;
        usdt_id = 1;
        max_coins = 8;

        // safety check for coin numbers matching what we expect
        require(address(usdc) == exchange.coins(usdc_id), "coin 0 != usdc");
        require(address(usdt) == exchange.coins(usdt_id), "coin 1 != usdt");

        approve();
    }

    /// @notice set max approvals
    /// @dev this probably won't ever need to be called again. but it doesn't hurt to expose
    function approve() public {
        usdc.approve(address(exchange), type(uint256).max);
        usdt.forceApprove(address(exchange), type(uint256).max);
        exchange.approve(address(vault), type(uint256).max);
    }

    /// TODO: vyper's default arguments would be helpful here
    /// TODO: support approvals
    function deposit(uint256 usdc_amount, uint256 usdt_amount, address receiver)
        public
        returns (uint256 vault_amount)
    {
        // TODO: i'm not sure that this way of creating "amounts" is correct. what is? should we use max_coins?
        uint256[] memory amounts = new uint256[](2);

        if (usdc_amount > 0) {
            usdc.transferFrom(msg.sender, address(this), usdc_amount);
            amounts[usdc_id] = usdc_amount;
        }
        if (usdt_amount > 0) {
            usdt.safeTransferFrom(msg.sender, address(this), usdt_amount);
            amounts[usdt_id] = usdt_amount;
        }

        uint256 lp_amount = exchange.add_liquidity(amounts, 0, address(this));

        // safety check. make sure that the lp tokens we received are worth close to what we deposited
        // TODO: should this check a balanced withdraw instead?
        uint256 heavy_id = heavyId();

        uint256 check = exchange.calc_withdraw_one_coin(lp_amount, int128(uint128(heavy_id)));

        // TODO: fullmultdiv?
        // TODO: configurable slippage? .1%?
        uint256 slipped = (usdc_amount + usdt_amount) * 999 / 1000;

        require(check >= slipped, "slippage");

        vault_amount = vault.deposit(lp_amount, receiver);
    }

    /// @notice recover any erc20 tokens accidentally sent to this contract
    /// @dev this zap contract doesn't hold any tokens. anything sent here should be returnable
    function recover(IERC20 token, uint256 amount, address receiver) public {
        require(msg.sender == donations, "not donations");

        token.safeTransfer(receiver, amount);
    }

    function _redeem(uint256 tokenId, uint256 shares, address receiver) internal returns (uint256 token_amount) {
        // // TODO: i want a "debug_require" that doesn't make it into the final contract
        // require(vault.allowance(msg.sender, address(this)) >= shares, "no allowance");
        // require(vault.balanceOf(msg.sender) >= shares, "no shares");

        vault.transferFrom(msg.sender, address(this), shares);

        uint256 exchange_amount = vault.withdraw(shares);

        // require(exchange.balanceOf(address(this)) >= exchange_amount, "no exchange balance");

        // TODO: safety check on token_amount
        token_amount = exchange.remove_liquidity_one_coin(exchange_amount, int128(uint128(tokenId)), 1, receiver);
    }

    function redeemBest(uint256 shares, address receiver) public returns (uint256 heavy_id, uint256 token_amount) {
        heavy_id = heavyId();
        token_amount = _redeem(heavy_id, shares, receiver);
    }

    function redeemUSDC(uint256 shares, address receiver) public returns (uint256 token_amount) {
        token_amount = _redeem(usdc_id, shares, receiver);
    }

    function redeemUSDT(uint256 shares, address receiver) public returns (uint256 token_amount) {
        token_amount = _redeem(usdt_id, shares, receiver);
    }

    function _withdraw(uint256 tokenId, uint256 amount, address receiver) internal returns (uint256 vault_shares) {
        // TODO: convert token amount into LP tokens and then to vault shares
        revert("wip");
        vault_shares = 0;

        _redeem(tokenId, vault_shares, receiver);
    }

    /// @notice since both tokens are redeemable 1:1 for USD, we probably often just want to withdraw the one that is heaviest
    function heavyId() public view returns (uint256 heavy_id) {
        // usdc has 6 decimals, usdt has 18 decimals
        // we must shift usdc up to 18 decimals to compare
        uint256 exchange_usdc = usdc.balanceOf(address(exchange));
        uint256 exchange_usdt = usdt.balanceOf(address(exchange));

        if (exchange_usdc >= exchange_usdt) {
            heavy_id = usdc_id;
        } else {
            heavy_id = usdt_id;
        }
    }

    function withdrawBest(uint256 amount, address receiver) public returns (uint256 heavy_id, uint256 vault_shares) {
        heavy_id = heavyId();
        vault_shares = _withdraw(heavy_id, amount, receiver);
    }

    function withdrawUSDC(uint256 c_amount, address receiver) public returns (uint256 vault_shares) {
        vault_shares = _withdraw(usdc_id, c_amount, receiver);
    }

    function withdrawUSDT(uint256 t_amount, address receiver) public returns (uint256 vault_shares) {
        vault_shares = _withdraw(usdt_id, t_amount, receiver);
    }

    function donate(uint256 c_amount, uint256 t_amount, uint256 lp_amount, uint256 vault_shares) external payable {
        // TODO: convert c_amount and t_amount to lp_amount
        // TODO: transfer lp_amount from msg.sender
        // TODO: transfer vault_amount from msg.sender

        revert("not implemented");
    }
}
