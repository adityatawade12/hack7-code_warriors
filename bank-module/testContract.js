const assert = require("assert")
const ganache = require("ganache-cli")
const { describe, it } = require("mocha")
const Web3 = require("web3")
const HDWalletProvider = require("truffle-hdwallet-provider")
const fs = require('fs');
require('dotenv').config()

const provider = new HDWalletProvider(
    process.env.nmeumo,
    process.env.address
)

// const web3 = new Web3(ganache.provider());
const web3 = new Web3(provider);

const {
    // bytecode,
    interface,
    bytecode1,
    interface1
} = require("../compile")

let accounts;
let factory;

beforeEach(async () => {
    //get a list of all acounts
    //use one of those accounts to deploy  the contacts
    accounts = await web3.eth.getAccounts();
    console.log("All accounts:", accounts);

    factory = await new web3.eth.Contract(interface1)
        .deploy({
            data: bytecode1,
            arguments: []
        })
        .send({
            from: accounts[0],
            gas: "3000000"
        });

    // console.log(inbox)

})


// write to a new file named 2pac.txt
fs.writeFile('D:/VEDANT/PROJECTS/college/BCT-MP/frontend/src/abi/poll_abi.json', JSON.stringify(interface), (err) => {
    // throws an error, you could also catch it here
    if (err) throw err;
});

fs.writeFile('D:/VEDANT/PROJECTS/college/BCT-MP/frontend/src/abi/factory_abi.json', JSON.stringify(interface1), (err) => {
    // throws an error, you could also catch it here
    if (err) throw err;
});

describe("Inbox", () => {

    // this.timeout(0);

    it("deploys a contract", () => {
        assert.ok(factory.options.address)
        console.log("contract factory add:", factory.options.address);
    });

    // it("Create unique polls", async () => {
    //     await factory.methods.createPoll(['a','b','c'], "hero poll").send({from: accounts[1], gas:"3000000"});
    // });

    it("Get individual poll data", async () => {
        await createNewPoll(accounts[1], 1);
        await createNewPoll(accounts[2], 2);
        await createNewPoll(accounts[3], 3);
        await createNewPoll(accounts[4], 4);

        const allPOlls = await factory.methods.getAllPolls().call();
        console.log("ALl polls: ", allPOlls);

/*         await factory.methods.createPoll(['a','b','c']).send({from: accounts[1], gas:"3000000"});

        const contAdd = await factory.methods.getDeployedPolls().call({from: accounts[1]});
        console.log("Address: ", contAdd);

        var cont = new web3.eth.Contract(interface, contAdd);
    
        await cont.methods.enter("a").send({
            from: accounts[5]
        });
        await cont.methods.enter("b").send({
            from: accounts[2]
        });
        await cont.methods.enter("b").send({
            from: accounts[3]
        });
        await cont.methods.enter("b").send({
            from: accounts[4]
        });
        const res = await cont.methods.pickWinner().call({
            from: accounts[1]
        });

        const res1 = await cont.methods.getVoters().call();


        console.log("Result:", res);
        console.log("Voters:", res1);
 */    
    });



    // it("has a default msg",async()=>{
    //     const message = await inbox.methods.message().call() 
    //     assert.equal(message,initStr)
    // })


    // it("can change msg",async()=>{
    // await inbox.methods.setMessage("bye").send({from:accounts[0]})

    // const message = await inbox.methods.message().call() 
    //     assert.equal(message,"bye")
    // })
})

const createNewPoll = async (creatorAccount, ind) => {
    await factory.methods.createPoll(['a','b','c'], `hero2poll${ind}`, `quest${ind}`).send({from: creatorAccount, gas:"3000000"});

    const contAdd = await factory.methods.getMyDeployedPolls().call({from: creatorAccount});
    console.log("Address: ", contAdd);

    var cont = new web3.eth.Contract(interface, contAdd[1]);

    let votes = ['a','b','c']

    for (let i = 1; i < 6; i++) {
        if (ind == i) continue;
        await cont.methods.enter(votes[Math.floor(3 * Math.random())]).send({
            from: accounts[i]
        });
        await cont.methods.checkIfManager().call().then((data) => {console.log("I:", i, " isManager: ", data)});
    }
    
    const res = await cont.methods.pickWinner().call({
        from: creatorAccount
    });

    const res1 = await cont.methods.getVoters().call();


    console.log("\nNew Poll:")

    console.log("Result:", res);
    console.log("Voters:", res1);
}