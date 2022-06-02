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

    modifier isDAO(){
        require(dao[msg.sender] == true, "You are not a DAO user");
        _;
    }

    event NewArtist(string name, string musicStyle, address artistAddress);
    event Authorized(string name, address artistAddress);
    event Refused(string name, address artistAddress);

    function addUserToDAO(address _addressDAO) external onlyOwner {
        require(dao[_addressDAO] == false, "user already in DAO");
        dao[_addressDAO] = true;
    }

    function addArtist(string memory _artistName, string memory _musicStyle) external {
        require(msg.sender != address(0), "you are nobody");
        require(whitelist[msg.sender].registered == false, "you are already registered");
        whitelist[msg.sender] = Artist(_artistName, _musicStyle, false, true, 0, 0, 0);
        emit NewArtist(_artistName, _musicStyle, msg.sender);
    } 

    function vote(bool _yes, address _artistAddress) external isDAO {
        if (_yes){
            whitelist[_artistAddress].yes++;
        } else if (!_yes) {
            whitelist[_artistAddress].no++;
        }
    }

    function authorizeArtist(address _artistAddress) external onlyOwner {
        
        require(whitelist[_artistAddress].authorized == false, "Artist already authorize");

        if (whitelist[_artistAddress].yes >= whitelist[_artistAddress].no) {
            whitelist[_artistAddress].authorized = true;
            emit Authorized(whitelist[_artistAddress].name, _artistAddress);
        } else {

            whitelist[_artistAddress] = Artist("", "", false, false, 0, 0, 0);
            emit Refused(whitelist[_artistAddress].name, _artistAddress);
        } 
    }

    function getArtist(address _artistAddress) external view returns(bool authorized) {
        return whitelist[_artistAddress].authorized;
    }
}