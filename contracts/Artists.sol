// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Artists is Ownable {
   
    struct Artist{
        string name;
        string musicStyle;
        bool authorized;
        bool registered;
        uint pochetteCount;
        uint yes;
        uint no;
    }

    mapping (address => Artist) private whitelist;
    mapping (address => bool) public dao;
    mapping (address => mapping(address => bool)) hasVoted;

    modifier isDAO(){
        require(dao[msg.sender] == true, "You are not a DAO user");
        _;
    }

    event NewArtist(string name, string musicStyle, address artistAddress);
    event Authorized(string name, address artistAddress);
    event Voted(address voter, address artist, bool vote);

    function addUserToDAO(address _addressDAO) external onlyOwner {
        require(dao[_addressDAO] == false, "user already in DAO");
        dao[_addressDAO] = true;
    }

    function addMeAsArtist(string memory _artistName, string memory _musicStyle) external {
        require(msg.sender != address(0), "you are nobody");
        require(whitelist[msg.sender].registered == false, "you are already registered");
        whitelist[msg.sender] = Artist(_artistName, _musicStyle, false, true, 0, 0, 0);
        emit NewArtist(_artistName, _musicStyle, msg.sender);
    } 

    function vote(bool _yes, address _artistAddress) external isDAO {
        require(hasVoted[msg.sender][_artistAddress] == false, "you have already voted");
        if (_yes){
            whitelist[_artistAddress].yes++;
        } else if (!_yes) {
            whitelist[_artistAddress].no++;
        }
        hasVoted[msg.sender][_artistAddress] = true;
        emit Voted(msg.sender, _artistAddress, _yes);
    }

    function authorizeMe() external { 
        require(whitelist[msg.sender].authorized == false, "Artist already authorize");
        require(whitelist[msg.sender].yes > whitelist[msg.sender].no + 10, "you have not enough vote to be authorize");
        whitelist[msg.sender].authorized = true;
        emit Authorized(whitelist[msg.sender].name, msg.sender);
    }

    function getArtist(address _artistAddress) external view returns(bool authorized) {
        return whitelist[_artistAddress].authorized;
    }
}