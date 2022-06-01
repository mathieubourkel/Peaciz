// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "./Peaciz.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Factory is IERC721Receiver, Ownable {

    address payable public immutable feeAccount;
    uint public immutable feePercent;
    uint public rate = 1000000000000000000;
    uint private pochetteCount;

    constructor(uint _feePercent) {
            feeAccount = payable(msg.sender);
            feePercent = _feePercent;
        }

    struct Pixel{
        uint pochetteId; 
        uint pixelId;
        uint price;
        Peaciz peaciz;
        address payable owner;
        bool onSale;
        string uri;
    }
        
    struct Pochette{
        uint pochetteId;
        uint pixelCount;
        Peaciz peaciz;
        address payable owner;
        string uri;
    }

    // struct Artist{
    //     string name;
    //     string musicStyle;
    //     bool authorized;
    //     bool registered;
    //     uint pochetteCount;
    // }

    mapping (uint => Pochette) pochettes;
    mapping (uint => mapping(uint => Pixel)) public pixelByPochette;
    // mapping (address => Artist) private whitelist;

    event NewArtist(string name, string musicStyle, address artistAddress);
    event Authorized(string name, address artistAddress);
    event NewPochette(uint pochetteId, address indexed pochetteAddress, address indexed owner, string uri);
    event Mint(uint pochetteId, uint pixelId, uint price, address indexed pochetteAddress, address indexed owner, string uri);

    // modifier isAuthorized() {
    //     require(whitelist[msg.sender].authorized == true, "you are not an authorized artist");
    //     _;
    // }

    modifier isValidNumber(uint _pochetteId, uint _pixelId) {
        require(_pochetteId > 0 && _pixelId > 0, "please enter a valid number");
        _;
    }

    // function addArtist(string memory _artistName, string memory _musicStyle) external {
    //     require(msg.sender != address(0), "you are nobody");
    //     require(whitelist[msg.sender].registered == false, "you are already registered");
    //     whitelist[msg.sender] = Artist(_artistName, _musicStyle, false, true, 0);
    //     emit NewArtist(_artistName, _musicStyle, msg.sender);
    // } 

    // function authorizeArtist(address _artistAddress) external onlyOwner {
    //     require(whitelist[_artistAddress].authorized == false, "you are already authorize");
    //     whitelist[_artistAddress].authorized = true;
    //     emit Authorized(whitelist[_artistAddress].name, _artistAddress);
    // }

    function createPochette(string memory _artistName, string memory _pochetteName, string memory _baseUri) external { 
        //Peaciz peaciz = new Peaciz{salt: _salt}(_artistName, _pochetteName, _baseUri); , bytes32 _salt 
        Peaciz peaciz = new Peaciz(_artistName, _pochetteName, _baseUri);
        pochetteCount++;
        pochettes[pochetteCount] = Pochette(pochetteCount, 0, peaciz, payable(msg.sender), _baseUri);
        emit NewPochette(pochetteCount, address(peaciz), msg.sender, _baseUri);
     }

     function makeItem(uint _pochetteId, string memory _uri) external {
        require(pochettes[_pochetteId].owner == payable(msg.sender), "you are not the pochette owner");
        pochettes[_pochetteId].peaciz.mint(_uri);
        uint _tempId = pochettes[_pochetteId].peaciz.getCount();
        pixelByPochette[_pochetteId][_tempId] = Pixel(_tempId, _pochetteId, 0, pochettes[_pochetteId].peaciz, payable(msg.sender), false, _uri);
        pochettes[_pochetteId].pixelCount++;
        pochettes[_pochetteId].peaciz.safeTransferFrom(address(this), msg.sender, _tempId);
        emit Mint(_pochetteId, _tempId, 0, address(pochettes[_pochetteId].peaciz), msg.sender, _uri);
    }

    function sellItem(uint _pochetteId, uint _pixelId, uint _price) external isValidNumber(_pochetteId, _pixelId){
        Pixel memory pixel = pixelByPochette[_pochetteId][_pixelId];  
        require(pixel.pixelId > 0 && pixel.pixelId <= pochettes[_pochetteId].pixelCount, "item doesnt exists");
        require(pixel.owner == msg.sender, "You are not the owner of the NFT");
        require(!pixel.onSale, "item already on the marketplace");
        pochettes[_pochetteId].peaciz.safeTransferFrom(msg.sender, address(this), _pixelId);
        pixel.onSale = true;
        pixel.price = _price * rate;
    }

    function purchaseItem(uint _pochetteId, uint _pixelId) external payable isValidNumber(_pochetteId, _pixelId){
        Pixel memory pixel = pixelByPochette[_pochetteId][_pixelId];  
        require(pixel.pixelId > 0 && pixel.pixelId <= pochettes[_pochetteId].pixelCount, "item doesnt exists");
        require(pixel.onSale, "item not on the marketplace"); 
        uint _totalPrice = getTotalPrice(_pochetteId, _pixelId);
        require(msg.value >= _totalPrice, "not enough ether to cover item price and market fee");
        pixel.owner.transfer(pixel.price); 
        feeAccount.transfer(_totalPrice - pixel.price);
        pixel.onSale = false;
      //  pixel.peaciz.transferFrom(pixel.owner, payable(msg.sender), _pixelId);
        pixel.owner = payable(msg.sender);
       // emit Bought( _itemId, address(item.nft), item.tokenId, item.price, item.owner, msg.sender);
    }

    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function getTotalPrice(uint _pochetteId, uint _pixelId) view public returns(uint) {
        return(pixelByPochette[_pochetteId][_pixelId].price*(100 + feePercent)/100);
    }
}