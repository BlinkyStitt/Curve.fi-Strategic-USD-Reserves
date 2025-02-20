// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ICurveStableSwapNG {
    function exchange(int128 i, int128 j, uint256 _dx, uint256 _min_dy) external returns (uint256);
    function exchange(int128 i, int128 j, uint256 _dx, uint256 _min_dy, address _receiver) external returns (uint256);
    function exchange_received(int128 i, int128 j, uint256 _dx, uint256 _min_dy) external returns (uint256);
    function exchange_received(int128 i, int128 j, uint256 _dx, uint256 _min_dy, address _receiver)
        external
        returns (uint256);
    function add_liquidity(uint256[] calldata _amounts, uint256 _min_mint_amount) external returns (uint256);
    function add_liquidity(uint256[] calldata _amounts, uint256 _min_mint_amount, address _receiver)
        external
        returns (uint256);
    function remove_liquidity_one_coin(uint256 _burn_amount, int128 i, uint256 _min_received)
        external
        returns (uint256);
    function remove_liquidity_one_coin(uint256 _burn_amount, int128 i, uint256 _min_received, address _receiver)
        external
        returns (uint256);
    function remove_liquidity_imbalance(uint256[] calldata _amounts, uint256 _max_burn_amount)
        external
        returns (uint256);
    function remove_liquidity_imbalance(uint256[] calldata _amounts, uint256 _max_burn_amount, address _receiver)
        external
        returns (uint256);
    function remove_liquidity(uint256 _burn_amount, uint256[] calldata _min_amounts)
        external
        returns (uint256[] memory);
    function remove_liquidity(uint256 _burn_amount, uint256[] calldata _min_amounts, address _receiver)
        external
        returns (uint256[] memory);
    function remove_liquidity(
        uint256 _burn_amount,
        uint256[] calldata _min_amounts,
        address _receiver,
        bool _claim_admin_fees
    ) external returns (uint256[] memory);
    function withdraw_admin_fees() external;
    function last_price(uint256 i) external view returns (uint256);
    function ema_price(uint256 i) external view returns (uint256);
    function get_p(uint256 i) external view returns (uint256);
    function price_oracle(uint256 i) external view returns (uint256);
    function D_oracle() external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    function permit(
        address _owner,
        address _spender,
        uint256 _value,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external returns (bool);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function get_dx(int128 i, int128 j, uint256 dy) external view returns (uint256);
    function get_dy(int128 i, int128 j, uint256 dx) external view returns (uint256);
    function calc_withdraw_one_coin(uint256 _burn_amount, int128 i) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function get_virtual_price() external view returns (uint256);
    function calc_token_amount(uint256[] calldata _amounts, bool _is_deposit) external view returns (uint256);
    function A() external view returns (uint256);
    function A_precise() external view returns (uint256);
    function balances(uint256 i) external view returns (uint256);
    function get_balances() external view returns (uint256[] memory);
    function stored_rates() external view returns (uint256[] memory);
    function dynamic_fee(int128 i, int128 j) external view returns (uint256);
    function ramp_A(uint256 _future_A, uint256 _future_time) external;
    function stop_ramp_A() external;
    function set_new_fee(uint256 _new_fee, uint256 _new_offpeg_fee_multiplier) external;
    function set_ma_exp_time(uint256 _ma_exp_time, uint256 _D_ma_time) external;
    function N_COINS() external view returns (uint256);
    function coins(uint256 arg0) external view returns (address);
    function fee() external view returns (uint256);
    function offpeg_fee_multiplier() external view returns (uint256);
    function admin_fee() external view returns (uint256);
    function initial_A() external view returns (uint256);
    function future_A() external view returns (uint256);
    function initial_A_time() external view returns (uint256);
    function future_A_time() external view returns (uint256);
    function admin_balances(uint256 arg0) external view returns (uint256);
    function ma_exp_time() external view returns (uint256);
    function D_ma_time() external view returns (uint256);
    function ma_last_time() external view returns (uint256);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function version() external view returns (string memory);
    function balanceOf(address arg0) external view returns (uint256);
    function allowance(address arg0, address arg1) external view returns (uint256);
    function nonces(address arg0) external view returns (uint256);
    function salt() external view returns (bytes32);
}
