
const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("EpicNFT")
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed()

    console.log("Contract deployed to: ", nftContract.address)

    let txn = await nftContract.makeNFT()
    await txn.wait()

    txn = await nftContract.makeNFT()
    await txn.wait()

}

const bootstrap = async () => {

    try {
        await main()
        process.exit(0)
    } catch (err) {
        console.error(err)
        process.exit(1)
    }
}

bootstrap();