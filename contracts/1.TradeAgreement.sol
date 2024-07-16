// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract TradeAgreement {
    address public sellerAddress;
    address public buyerAddress;
    string public item;
    uint256 public price;
    bool public buyerAccepted;
    bool public sellerAccepted;
    bool public tradeCompeleted;
    bool public depositMade;

    event TradeCreated(address indexed sellerAddress, address indexed buyerAddress, uint price, string item);
    event BuyerAccepted(address indexed buyerAddress);
    event SellerAccepted(address indexed sellerAddress);
    event TradeCompeleted(address indexed sellerAddress, address indexed buyerAddress);

    constructor(
        address _buyerAddress,
        string memory _item,
        uint256 _price
    ) {
        sellerAddress = msg.sender;
        buyerAddress = _buyerAddress;
        item = _item;
        price = _price;
    }

    modifier onlyBuyer() {
        require(
            msg.sender == buyerAddress,
            "Only buyer can call this function"
        );
        _;
    }

    modifier onlySeller() {
        require(
            msg.sender == sellerAddress,
            "Only seller can call this function"
        );
        _;
    }

    function deposit() public payable onlyBuyer {
        require(
            buyerAccepted == true,
            "Buyer hasn't already accepted the trade"
        );
        require(!depositMade, "Deposit already made");
        require(msg.value == price, "Incorrect Amount");
        depositMade = true;
    }

    function acceptTradeAsSeller() public onlySeller {
        require(
            sellerAccepted == false,
            "Seller has already accepted the trade"
        );
        require(depositMade, "Deposit not made");
        sellerAccepted = true;
        emit SellerAccepted(sellerAddress);
        completeTrade();
    }

    function acceptTradeAsBuyer() public onlyBuyer {
        require(buyerAccepted == false, "Buyer has already accepted the trade");
        buyerAccepted = true;
        emit SellerAccepted(buyerAddress);
        completeTrade();
    }

    function completeTrade() internal {
        if (buyerAccepted && sellerAccepted) {
            tradeCompeleted = true;
            emit TradeCompeleted(sellerAddress, buyerAddress);
            payable(sellerAddress).transfer(price);
        } else {
            require(tradeCompeleted == false, "Trade Already Compeleted");
        }
    }
}
