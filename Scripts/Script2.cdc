// Script2.cdc

import FungibleToken from 0x01cf0e2f2f715450
import NonFungibleToken from 0x179b6b1cb6755e31
import Marketplace from 0xf3fcd2c1a78f5eee

// This script prints the NFTs that account 0x01 has for sale.
pub fun main() {
    // Get the public account object for account 0x01
    let account1 = getAccount(0x01cf0e2f2f715450)

    // Find the public Sale reference to their Collection
    let acct1saleRef = account1.getCapability<&AnyResource{Marketplace.SalePublic}>(/public/NFTSale)
        .borrow()
        ?? panic("Could not borrow acct2 nft sale reference")

    // Los the NFTs that are for sale
    log("Account 1 NFTs for sale")
    log(acct1saleRef.getIDs())
    log("Price")
    log(acct1saleRef.idPrice(tokenID: 1))
}
 