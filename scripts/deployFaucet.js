const hre = require("hardhat");

async function main() {
    const Faucet = await hre.ethers.getContractFactory("Faucet");
    const faucet = await Faucet.deploy("0x3C16855E6Ae4dFe027F9Bfc9FAb71114d18C9db9");

    await faucet.deployed();

    console.log("Faucet contract deployed: ", faucet.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});