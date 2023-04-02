import Head from "next/head"
import Image from "next/image";
import { useEffect, useState } from "react";

const Withdraw = () => {

	const [amount, setAmount] = useState(0);
	const [accId, setAccId] = useState("");
	const [accBalance, setaccBalance] = useState(0.004);
	const [effAccBalance, setEffAccBalance] = useState(0.004);

		const [web3, setweb3] = useState(null);
	const [account, setaccount] = useState('');
	const [token, settoken] = useState(null);
	const [dbank, setdbank] = useState(null);
	const [balance, setbalance] = useState(0);
	const [borrowAmount, setborrowAmount] = useState(0);
	const [dBankAddress, setdBankAddress] = useState(null);

	
    const initializeEth = () => {
        if(window.ethereum){
            // Do something 
            window.ethereum.request({method:'eth_requestAccounts'})
            .then(async (res)=>{
                // Return the address of the wallet
                console.log(res)
                setweb3(new Web3(window.ethereum));
				if (res[0] !== null) {
					setaccount(res[0])
				}
				else {
					window.alert('Please login with metamask')
				}
            })
        }else{
            alert("install metamask extension!!")
        }
    }

    useEffect(()=> {
		if (web3 != null) {
			console.log("acc:", account, ",  web3:", web3);
			const bal = web3.eth.getBalance(account);
			setbalance(bal);
	
			try {
				const netId = web3.eth.net.getId();
				const tk = new web3.eth.Contract(tokenABI.abi, tokenABI.networks[netId].address)
				const dbk = new web3.eth.Contract(bankABI.abi, bankABI.networks[netId].address)
				const dbkAdd = bankABI.networks[netId].address
				settoken(tk);
				setdbank(dbk);
				setdBankAddress(dbkAdd);
			}
			catch (e) {
				console.log('Error', e)
				window.alert('Contracts not deployed to the current network')
			}
		}
    }, [web3]);

    useEffect(()=> {
        if (isBrowser()) {
            initializeEth();
        }
    }, []);

	useEffect(()=> {
		setEffAccBalance(accBalance - amount);
	}, [amount]);
	
	const handleWithdrawal = (eve) => {
		eve.preventDefault();
		console.log("Amount Withrawed:", amount);
	}

    return <>
        <Head>
			<title>Withdraw Money: Bit Finance Bank</title>
			<meta name="description" content="Withdraw money " />
			<meta name="viewport" content="width=device-width, initial-scale=1" />
		</Head>
        <main>
			<div className="vw-100 vh-100 flex flex-column border-0 blue-bg">
                <Image className="mb-3" src={"/logo.png"} width={140} height={140} alt="logo" />
                <form className="bg-white p-5 rounded shadow text-dark"  onSubmit={handleWithdrawal}>
                    <h4 className="text-center mb-4">Withdraw Money</h4>
					<div className="mb-3 px-3 mx-3">
                        <label className="form-label w-100">Account Id</label>
                        <div className="ui left icon input action w-100">
                            <i aria-hidden="true" className="icon far fa-id-card"></i>
                            <input type="text" id="accId" placeholder="" readOnly value={accId}/>
                        </div>
                    </div>
                    <div className="mb-3 px-3 mx-3">
						<div className="row">
							<div className="col-6"  style={{ maxWidth: "175px" }}>
								<label className="form-label w-100">Original Balance</label>
								<div className="ui left icon input action w-100">
									<i aria-hidden="true" className="icon far fa-file-invoice"></i>
									<input className="me-1" type="number" id="currBal1" placeholder="" readOnly value={accBalance}/>
								</div>
							</div>
							<div className="col-6"  style={{ maxWidth: "175px" }}>
								<label className="form-label w-100">Effective Balance</label>
								<div className="ui left icon input action w-100">
									<i aria-hidden="true" className="icon far fa-file-invoice"></i>
									<input className="me-1" type="number" id="currBal2" placeholder="" readOnly value={effAccBalance}/>
								</div>
							</div>
						</div>
                    </div>
					<div className="mb-3 px-3 mx-3">
                        <label className="form-label w-100">Enter amount</label>
                        <div className="ui left icon input w-100">
                            <i aria-hidden="true" className="icon far fa-ethereum"></i>
                            <input type="number" id="amount" min="0" step="0.0001" max={accBalance} value={amount} onChange={e => setAmount(e.target.value)} />
							<div class="ui label d-flex flex">Eth</div>
                        </div>
                    </div>
                    <div className="flex w-100 mt-4">
                        <button className="ui blue-btn button" type="submit">Confirm</button>
                    </div>
                </form>
            </div>
        </main>
    </>;
}

export default Withdraw;