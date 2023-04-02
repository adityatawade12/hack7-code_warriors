import Head from 'next/head'
import styles from '@/styles/Home.module.css'
import { useEffect, useState } from 'react'

import Web3 from "web3";
import bankABI from "@/contract/abi/dbank.json"
import tokenABI from '@/contract/abi/Token.json'

import Image from 'next/image';
import { useRouter } from 'next/router';

const isBrowser = () => typeof window !== 'undefined';

export default function Home() {

	const router = useRouter();

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

	return (<>
		<Head>
			<title>BIT FINANCE BANK</title>
			<meta name="description" content="Bit finance Bank: deposit, withdraw your own crypto-currency" />
			<meta name="viewport" content="width=device-width, initial-scale=1" />
		</Head>
		
		<main className={styles.main + " vw-100 vh-100 flex flex-column border-0 blue-bg"}>
                <Image className="mb-3" src={"/logo.png"} width={300} height={300} alt="logo" />
				<h1 className='display-2 my-3'>BIT FINANCE BANK</h1>

				<div className="flex w-100 mt-4">
					<button className="ui fs-5 fw-bold blue-btn button mx-2" onClick={()=> router.push("/login")}>Get Started</button>
				</div>
		</main>
	</>)
}
