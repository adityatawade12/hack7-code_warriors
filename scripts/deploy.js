const hre = require("hardhat");

async function main() {
  const KJHToken = await hre.ethers.getContractFactory("KJHToken");
  const kjhToken = await KJHToken.deploy(100000000, 50);

  await kjhToken.deployed();

  console.log("KJH Token deployed: ", kjhToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});