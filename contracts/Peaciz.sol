// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Peaciz is ERC721URIStorage, Ownable, ReentrancyGuard {

    using Counters for Counters.Counter;
    Counters.Counter private tokenCount;

    constructor(string memory _name, string memory _symbol, string memory _baseUri)
        ERC721(_name, _symbol)
        ReentrancyGuard()
        {}

    function mint(string memory _tokenURI) public nonReentrant onlyOwner {
        tokenCount.increment();
        _safeMint(msg.sender, tokenCount.current());
        _setTokenURI(tokenCount.current(), _tokenURI);
    }

    function getCount() public view returns (uint) {
        return tokenCount.current();
    }

}