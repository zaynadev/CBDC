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
    event UpdateInterestRate(uint oldInterest, uint newInterest);
    event IncreaseMoneySupply(uint oldMoneySupply, uint inflationAmount);
    event UpdateBlacklist(address criminal, bool blocked);
    event StakeTreasuryBond(address user, uint amount);
    event UnstakeTreasuryBond(address user, uint amount);
    event ClaimTreasuryBond(address user, uint amount);

    constructor(
        address _governement,
        uint initialSupply
    ) ERC20("Central Bank Digital Currency", "CBDC") {
        governement = _governement;
        _mint(_governement, initialSupply);
    }

    modifier onlyGovernement() {
        require(msg.sender == governement);
        _;
    }

    function updateGovernement(address newGov) external onlyGovernement {
        address oldGov = governement;
        governement = newGov;
        _transfer(oldGov, newGov, balanceOf(oldGov));
        emit UpdateGovernement(oldGov, newGov);
    }

    function _UpdateInterestRate(uint newInterest) external onlyGovernement {
        uint oldInterestRate = interestRateBasisPoints;
        interestRateBasisPoints = newInterest;
        emit UpdateInterestRate(oldInterestRate, newInterest);
    }
}
