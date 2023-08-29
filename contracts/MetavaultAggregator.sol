// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.16;

import {IERC20} from "../src/interfaces/IERC20.sol";
import {SafeMath} from "../src/libraries/SafeMath.sol";
import {IMvlpManager} from "../src/interfaces/IMvlpManager.sol";

contract MetavaultAggregator{
    uint256 public constant divider = 1000000;
    uint256 public constant decimal = 6;
    address private mvlpManager = 0x13E733dDD6725a8133bec31b2Fc5994FA5c26Ea9;
    address private mvlpToken = 0x9F4f8bc00F48663B7C204c96b932C29ccc43A2E8;

    function getAUM(bool maximise) external view returns (uint256) {
        IMvlpManager _manager = IMvlpManager(mvlpManager);
        return _manager.getAumInUsdm(maximise);
    }

    function getSupply() external view returns (uint256) {
        IERC20 _mvlp = IERC20(mvlpToken);
        return _mvlp.totalSupply();
    }

    function getPriceBuy() external view returns (uint256) {
        IERC20 _mvlp = IERC20(mvlpToken);
        IMvlpManager _manager = IMvlpManager(mvlpManager);

        uint256 supply = _mvlp.totalSupply();
        uint256 aumMax = _manager.getAumInUsdm(true);

        (bool success, uint256 result) = SafeMath.tryDiv(aumMax * divider, supply);
        if (!success) {
            return 0;
        }
        return result;
    }

    function getPriceSell() external view returns (uint256) {
        IERC20 _mvlp = IERC20(mvlpToken);
        IMvlpManager _manager = IMvlpManager(mvlpManager);

        uint256 supply = _mvlp.totalSupply();
        uint256 aumMin = _manager.getAumInUsdm(false);

        (bool success, uint256 result) = SafeMath.tryDiv(aumMin * divider, supply);
        if (!success) {
            return 0;
        }
        return result;
    }
}