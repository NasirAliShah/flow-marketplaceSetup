// Transaction2.cdc
import FungibleToken from 0x01cf0e2f2f715450
import NonFungibleToken from 0x179b6b1cb6755e31
import Marketplace from 0xf3fcd2c1a78f5eee

// This transaction uses the signers Vault tokens to purchase an NFT
// from the Sale collection of account 0x01.
transaction {

    // reference to the buyer's NFT collection where they
    // will store the bought NFT
    let collectionRef: &AnyResource{NonFungibleToken.NFTReceiver}

    // Vault that will hold the tokens that will be used to
    // but the NFT
    let temporaryVault: @FungibleToken.Vault

    prepare(acct: AuthAccount) {

        // get the references to the buyer's fungible token Vault and NFT Collection Receiver
        self.collectionRef = acct.borrow<&AnyResource{NonFungibleToken.NFTReceiver}>(from: /storage/NFTCollection)!
        let vaultRef = acct.borrow<&FungibleToken.Vault>(from: /storage/MainVault)
            ?? panic("Could not borrow owner's vault reference")

        // withdraw tokens from the buyers Vault
        self.temporaryVault <- vaultRef.withdraw(amount: 10.0)
    }

    execute {
        // get the read-only account storage of the seller
        let seller = getAccount(0x01cf0e2f2f715450)

        // get the reference to the seller's sale
        let saleRef = seller.getCapability<&AnyResource{Marketplace.SalePublic}>(/public/NFTSale)
            .borrow()
            ?? panic("Could not borrow seller's sale reference")

        // purchase the NFT the the seller is selling, giving them the reference
        // to your NFT collection and giving them the tokens to buy it
        saleRef.purchase(tokenID: 1, recipient: self.collectionRef, buyTokens: <-self.temporaryVault)

        log("Token 1 has been bought by account 2!")
    }
}
 
 