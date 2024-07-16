## TradeAgreement Contract Documentation
### Overview
The TradeAgreement contract facilitates a trade between a buyer and a seller. It ensures that both parties accept the trade terms before transferring the agreed-upon price from the buyer to the seller. The contract manages the state of the trade and ensures that all conditions are met before completion.

### Contract Details
#### State Variables
- address public sellerAddress; - Stores the address of the seller.
- address public buyerAddress; - Stores the address of the buyer.
- string public item; - Description of the item being traded.
- uint256 public price; - The agreed price for the item.
- bool public buyerAccepted; - Indicates if the buyer has accepted the trade.
- bool public sellerAccepted; - Indicates if the seller has accepted the trade.
- bool public tradeCompleted; - Indicates if the trade has been completed.
- bool public depositMade; - Indicates if the deposit has been made by the buyer.
#### Events
- event TradeCreated(address indexed sellerAddress, address indexed buyerAddress, uint price, string item); - Emitted when the trade is created.
- event BuyerAccepted(address indexed buyerAddress); - Emitted when the buyer accepts the trade.
- event SellerAccepted(address indexed sellerAddress); - Emitted when the seller accepts the trade.
- event TradeCompleted(address indexed sellerAddress, address indexed buyerAddress); - Emitted when the trade is completed.
#### Constructor
The constructor initializes the contract with the buyer's address, the item description, and the price. The seller's address is set to the address that deploys the contract.

#### Solidity
```

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
```
#### Modifiers
```
modifier onlyBuyer() - Ensures that only the buyer can call the function.
modifier onlySeller() - Ensures that only the seller can call the function.
```
#### Functions
```deposit()```

#### Allows the buyer to deposit the agreed price into the contract.
##### Conditions:
- The buyer must have accepted the trade.
- The deposit has not been made previously.
- The deposited amount must match the agreed price.
- Modifiers: onlyBuyer
##### Solidity
```
function deposit() public payable onlyBuyer {
    require(buyerAccepted == true, "Buyer hasn't already accepted the trade");
    require(!depositMade, "Deposit already made");
    require(msg.value == price, "Incorrect Amount");
    depositMade = true;
}
```
```
acceptTradeAsSeller()
```
#### Allows the seller to accept the trade.
##### Conditions:
- The seller has not accepted the trade previously.
-The deposit must have been made by the buyer.
- Modifiers: onlySeller
##### Solidity
```
function acceptTradeAsSeller() public onlySeller {
    require(sellerAccepted == false, "Seller has already accepted the trade");
    require(depositMade, "Deposit not made");
    sellerAccepted = true;
    emit SellerAccepted(sellerAddress);
    completeTrade();
}
```
```acceptTradeAsBuyer()```

#### Allows the buyer to accept the trade.
##### Conditions:
- The buyer has not accepted the trade previously.
- Modifiers: onlyBuyer
##### Solidity
```
function acceptTradeAsBuyer() public onlyBuyer {
    require(buyerAccepted == false, "Buyer has already accepted the trade");
    buyerAccepted = true;
    emit BuyerAccepted(buyerAddress);
    completeTrade();
}
```

```completeTrade()```

#### An internal function to complete the trade.
##### Conditions:
- Both the buyer and the seller must have accepted the trade.
- Transfers the agreed price to the seller and emits the TradeCompleted event.
##### Solidity
```
function completeTrade() internal {
    if (buyerAccepted && sellerAccepted) {
        tradeCompleted = true;
        emit TradeCompleted(sellerAddress, buyerAddress);
        payable(sellerAddress).transfer(price);
    } else {
        require(tradeCompleted == false, "Trade Already Completed");
    }
}
```
### Usage Example
##### 1. Deploy the Contract
- The seller deploys the contract with the buyer's address, item description, and price.

##### 2. Buyer Accepts the Trade
- The buyer calls acceptTradeAsBuyer() to accept the trade.
  
##### 3. Buyer Deposits the Price
- The buyer calls deposit() and sends the price amount to the contract.
  
##### 4. Seller Accepts the Trade
- The seller calls acceptTradeAsSeller() to accept the trade.
  
##### 5. Trade Completion
- Once both parties have accepted the trade and the deposit is made, the contract automatically transfers the price to the seller and emits the TradeCompleted event.
This smart contract ensures that both parties agree to the terms and that the payment is securely handled before the trade is considered complete.
