// Script3.cdc

import FungibleToken from 0x01cf0e2f2f715450
import NonFungibleToken from 0x179b6b1cb6755e31
import Marketplace from 0xf3fcd2c1a78f5eee

// This script checks that the Vault balances and NFT collections are correct
// for both accounts.
//
// Account 1: Vault balance = 50, No NFTs
// Account 2: Vault balance = 10, NFT ID=1
pub fun main() {
    // Get the accounts' public account objects
    let acct1 = getAccount(0x01cf0e2f2f715450)
    let acct2 = getAccount(0x179b6b1cb6755e31)

    // Get references to the account's receivers
    // by getting their public capability
    // and borrowing a reference from the capability
    let acct1ReceiverRef = acct1.getCapability<&FungibleToken.Vault{FungibleToken.Balance}>(/public/MainReceiver)
        .borrow()
        ?? panic("Could not borrow acct1 vault reference")

    let acct2ReceiverRef = acct2.getCapability<&FungibleToken.Vault{FungibleToken.Balance}>(/public/MainReceiver)
        .borrow()
        ?? panic("Could not borrow acct2 vault reference")

    // Log the Vault balance of both accounts and ensure they are
    // the correct numbers.
    // Account 0x01 should have 50.
    // Account 0x02 should have 10.
    log("Account 1 Balance")
	log(acct1ReceiverRef.balance)
    log("Account 2 Balance")
    log(acct2ReceiverRef.balance)

    // verify that the balances are correct
    if acct1ReceiverRef.balance != 50.0 || acct2ReceiverRef.balance != 10.0 {
        panic("Wrong balances!")
    }

    // Find the public Receiver capability for their Collections
    let acct1Capability = acct1.getCapability(/public/NFTReceiver)
    let acct2Capability = acct2.getCapability(/public/NFTReceiver)

    // borrow references from the capabilities
    let nft1Ref = acct1Capability.borrow<&{NonFungibleToken.NFTReceiver}>()
        ?? panic("Could not borrow acct1 nft collection reference")

    let nft2Ref = acct2Capability.borrow<&{NonFungibleToken.NFTReceiver}>()
        ?? panic("Could not borrow acct2 nft collection reference")

    // Print both collections as arrays of IDs
    log("Account 1 NFTs")
    log(nft1Ref.getIDs())

    log("Account 2 NFTs")
    log(nft2Ref.getIDs())

    // verify that the collections are correct
    if nft2Ref.getIDs()[0] != 1 as UInt64 || nft1Ref.getIDs().length != 0 {
        panic("Wrong Collections!")
    }

    // Get the public sale reference for Account 0x01
    let acct1SaleRef = acct1.getCapability<&AnyResource{Marketplace.SalePublic}>(/public/NFTSale)
        .borrow()
        ?? panic("Could not borrow acct1 nft sale reference")

    // Print the NFTs that account 0x01 has for sale
    log("Account 1 NFTs for sale")
    log(acct1SaleRef.getIDs())
    if acct1SaleRef.getIDs().length != 0 { panic("Sale should be empty!") }
}

