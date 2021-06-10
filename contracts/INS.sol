// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "./utils/ERC20Burnable.sol";
import "./utils/SafeMath.sol";
import "./owner/AdminRole.sol";

contract INS is ERC20Burnable, AdminRole {
    using SafeMath for uint256;

    uint256 public _minimumSupply = 0;

    constructor(string memory name_, string memory symbol_)
        ERC20(name_, symbol_)
    {
        _mint(0x0887384d68b51caA2743670A63056514f418ABA7, 75 * 10**7 * 10**18);
        _mint(0x206d6d28622508448eB0eB06872Eb9254BF96407, 2 * 10**8 * 10**18);
        _mint(0x42C33D986b13B5E8D4aDDaF8fddFf3c77Ad3FD74, 25 * 10**6 * 10**18);
        _mint(0x344Dd2cfE9c6fd9Fce55957B12153442a94AaD51, 25 * 10**6 * 10**18);
    }

    function transfer(address to, uint256 amount)
        public
        override
        returns (bool)
    {
        return super.transfer(to, _amountafterBurn(amount));
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        return super.transferFrom(from, to, _amountafterBurn(amount));
    }

    function _amountafterBurn(uint256 amount) internal returns (uint256) {
        uint256 burnAmount = _calculateBurnAmount(amount);

        if (burnAmount > 0) {
            _burn(msg.sender, burnAmount);
        }

        return amount.sub(burnAmount);
    }

    function _calculateBurnAmount(uint256 amount)
        internal
        view
        returns (uint256)
    {
        uint256 burnAmount = 0;
        // burn amount calculations
        if (totalSupply() > _minimumSupply) {
            burnAmount = amount.mul(1).div(100);
            uint256 availableBurn = totalSupply().sub(_minimumSupply);
            if (burnAmount > availableBurn) {
                burnAmount = availableBurn;
            }
        }

        return burnAmount;
    }

    function setMinimumSupply(uint256 amount) external onlyAdmin {
        _minimumSupply = amount;
    }
}
