// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.16;

contract PipMock {
    uint256 price;

    function setPrice(uint256 price_) external {
        price = price_;
    }

    function read() external view returns (uint256 price_) {
        price_ = price;
    }

    function peek() external view returns (uint256 price_, bool ok) {
        ok = true;
        price_ = price;
    }
}