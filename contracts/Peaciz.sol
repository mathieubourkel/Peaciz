// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Peaciz is ERC721URIStorage, Ownable, ReentrancyGuard {

    using Counters for Counters.Counter;
    Counters.Counter private tokenCount;
    address private immutable marketplace;

    constructor(string memory _name, string memory _symbol, address _marketplace)
        ERC721(_name, _symbol)
        ReentrancyGuard()
        {
            marketplace = _marketplace;
        }

    function mint(string memory _tokenURI) external nonReentrant onlyOwner {
        tokenCount.increment();
        _safeMint(msg.sender, tokenCount.current());
        _setTokenURI(tokenCount.current(), _tokenURI);
    }

    function getCount() external view returns (uint) {
        return tokenCount.current();
    }

    function isApprovedForAll(address owner, address operator) override public view returns(bool) {
        if (address(marketplace) == operator) {
            return true;
        }
        return super.isApprovedForAll(owner, operator);
    }

}