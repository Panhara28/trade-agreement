// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract TradeAgreement{
    address public seller;
    address public buyer;
    uint256 public amount;
    string public item;
    bool public buyerAccepted;
    bool public sellerAccepted;
    bool public tradeCompeleted;

    event TradeCreated(address indexed seller, address indexed buyer, uint amount, string item);
    event BuyerAccepted(address indexed buyer);
    event SellerAccepted(address indexed seller);
    event TradeCompeleted(address indexed seller, address indexed buyer);

    constructor(address _buyer, uint256 _amount, string memory _item){
        seller = msg.sender;
        buyer = _buyer;
        amount = _amount * 10**18;
        item = _item;
        buyerAccepted = false;
        sellerAccepted = false;
        tradeCompeleted = false;

        emit TradeCreated(seller, buyer, amount, item);
    }

    modifier onlyBuyer(){
        require(msg.sender == buyer, "Only buyer can call this function");
        _;
    }

    modifier onlySeller(){
        require(msg.sender == seller, "Only seller can call this function");
        _;
    }

    function acceptTradeAsBuyer() public onlyBuyer{
        buyerAccepted = true;
        emit BuyerAccepted(buyer);
        completeTrade();
    }

    function acceptTradeAsSeller() public onlySeller{
        sellerAccepted = true;
        emit SellerAccepted(seller);
        completeTrade();
    }

    function completeTrade() internal {
        if(buyerAccepted && sellerAccepted){
            tradeCompeleted = true;
            emit TradeCompeleted(seller, buyer);
            payable(seller).transfer(amount);
        }else{
            require(tradeCompeleted == false, "Trade Already Compeleted");
        }
    }

    function deposit() public payable onlyBuyer{
        require(msg.value == amount, "Incorrect Amount");
    }

    function getTradeStatus() public view returns(bool){
        return tradeCompeleted;
    }

}