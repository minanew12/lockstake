// SPDX-FileCopyrightText: © 2023 Dai Foundation <www.daifoundation.org>
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity ^0.8.16;

interface VatLike {
    function hope(address) external;
}

interface GemLike {
    function balanceOf(address) external view returns (uint256);
    function approve(address, uint256) external;
    function transfer(address, uint256) external;
}

interface StakingRewardsLike {
    function rewardsToken() external view returns (GemLike);
    function stake(uint256, uint16) external;
    function withdraw(uint256) external;
    function getReward() external;
}

contract LockstakeUrn {
    // --- immutables ---

    address immutable public engine;
    GemLike immutable public stkNgt;

    // --- modifiers ---

    modifier isEngine {
        require(msg.sender == engine, "LockstakeUrn/not-engine");
        _;
    }

    // --- constructor ---

    constructor(address vat_, address stkNgt_) {
        engine = msg.sender;
        stkNgt = GemLike(stkNgt_);
        VatLike(vat_).hope(msg.sender);
        stkNgt.approve(msg.sender, type(uint256).max);
    }

    // --- staking functions ---

    function stake(address farm, uint256 wad, uint16 ref) external isEngine {
        stkNgt.approve(farm, wad);
        StakingRewardsLike(farm).stake(wad, ref);
    }

    function withdraw(address farm, uint256 amt) external isEngine{
        StakingRewardsLike(farm).withdraw(amt);
    }

    function getReward(address farm, address usr) external isEngine {
        StakingRewardsLike(farm).getReward();
        GemLike rewardsToken = StakingRewardsLike(farm).rewardsToken();
        rewardsToken.transfer(usr, rewardsToken.balanceOf(address(this)));
    }
}
