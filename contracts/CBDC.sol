//SPDX-License-Identifer: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CBDC is ERC20 {
    address public governement;
    uint public interestRateBasisPoints = 500; // 5%
    mapping(address => bool) public blacklist;
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

    function increaseMoneySupply(
        uint inflationAmount
    ) external onlyGovernement {
        uint oldMoneySupply = totalSupply();
        _mint(msg.sender, inflationAmount);
        emit IncreaseMoneySupply(oldMoneySupply, inflationAmount);
    }

    function updateBlacklist(
        address criminal,
        bool blacklisted
    ) external onlyGovernement {
        blacklist[criminal] = blacklisted;
        emit UpdateBlacklist(criminal, blacklisted);
    }

    function stakeTreasuryBonds(uint amount) external {
        require(amount > 0);
        require(balanceOf(msg.sender) >= amount);
        _transfer(msg.sender, address(this), amount);
        stakedTeasuryBond[msg.sender] += amount;
        stakedFromTS[msg.sender] = block.timestamp;
        emit StakeTreasuryBond(msg.sender, amount);
    }

    function unstakeTreasuryBonds(uint amount) external {
        require(amount > 0);
        require(stakedTeasuryBond[msg.sender] >= amount);
        stakedTeasuryBond[msg.sender] -= amount;
        claimTreasuryBond();
        _transfer(address(this), msg.sender, amount);
    }

    function claimTreasuryBond() public {
        require(stakedTeasuryBond[msg.sender] > 0);
        uint secondsStack = block.timestamp - stakedFromTS[msg.sender];
        uint reward = (stakedTeasuryBond[msg.sender] *
            secondsStack *
            interestRateBasisPoints) / (10000 * 3.154e7);
        stakedFromTS[msg.sender] = block.timestamp;
        _mint(msg.sender, reward);
        emit ClaimTreasuryBond(msg.sender, reward);
    }

    function _transfer(
        address from,
        address to,
        uint amount
    ) internal override {
        require(blacklist[from] == false);
        require(blacklist[to] == false);
        super._transfer(from, to, amount);
    }
}
