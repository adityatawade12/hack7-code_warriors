import Head from 'next/head'
import styles from '@/styles/Home.module.css'
import { useEffect, useState } from 'react'

// import Token from '../abis/Token.json'

import Web3 from 'web3';
import Image from 'next/image';
import { useRouter } from 'next/router';

export default function Home() {

	const router = useRouter();

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
