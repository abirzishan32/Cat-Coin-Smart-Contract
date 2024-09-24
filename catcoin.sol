// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract catcoin_ico {
    // Introducing the max number of Catcoins available for sale
    uint public max_catcoins = 1000000;

    // Introducing US Dollar to Catcoin conversion rate
    uint public usd_to_catcoin = 1000;

    // Introducing total number of Catcoin that have been bought by the investors
    uint public total_catcoins_bought = 0;

    // Mapping the investor address to its equity in Catcoins and USD
    mapping(address => uint) equity_catcoins;
    mapping(address => uint) equity_usd;

    // Checking if an investor can buy Catcoins (if there are enough Catcoins left)
    modifier can_buy_catcoins(uint usd_invested) {
        require(usd_invested * usd_to_catcoin + total_catcoins_bought <= max_catcoins, "Not enough Catcoins available.");
        _;
    }

    // Checking if an investor has enough Catcoins to sell
    modifier can_sell_catcoins(address investor, uint catcoins_sold) {
        require(equity_catcoins[investor] >= catcoins_sold, "Not enough Catcoins to sell.");
        _;
    }

    // Getting the equity in Catcoins of an investor
    function equity_in_catcoins(address investor) external view returns (uint) {
        return equity_catcoins[investor];
    }

    // Getting the equity in USD of an investor
    function equity_in_usd(address investor) external view returns (uint) {
        return equity_usd[investor];
    }

    // Buying Catcoins
    function buy_catcoins(address investor, uint usd_invested) external can_buy_catcoins(usd_invested) returns (uint) {
        uint catcoins_bought = usd_invested * usd_to_catcoin;
        equity_catcoins[investor] += catcoins_bought;
        equity_usd[investor] = equity_catcoins[investor] / usd_to_catcoin;
        total_catcoins_bought += catcoins_bought;
        return equity_catcoins[investor];
    }

    // Selling Catcoins
    function sell_catcoins(address investor, uint catcoins_sold) external can_sell_catcoins(investor, catcoins_sold) returns (uint) {
        equity_catcoins[investor] -= catcoins_sold;
        equity_usd[investor] = equity_catcoins[investor] / usd_to_catcoin;
        total_catcoins_bought -= catcoins_sold;
        return equity_catcoins[investor];
    }
}
