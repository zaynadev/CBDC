//SPDX-License-Identifer: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CBDC is ERC20 {
    address public governement;
    uint public interestRateBasisPoints = 500; // 5%
    mapping(address => uint) public blacklist;
    mapping(address => uint) private stakedTeasuryBond; // amount
    mapping(address => uint) private stakedFromTS; // timestamp
    event UpdateGovernement(address oldGov, address newGov);
    event UpdateInterestRate(address oldInterest, address newInterest);
    event IncreaseMoneySupply(uint oldMoneySupply, uint inflationAmount);
    event UpdateBlacklist(address criminal, bool blocked);
    event StakeTreasuryBond(address user, uint amount);
    event UnstakeTreasuryBond(address user, uint amount);
    event ClaimTreasuryBond(address user, uint amount);
}
