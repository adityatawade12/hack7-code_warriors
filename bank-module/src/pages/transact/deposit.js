import Head from "next/head"
import Image from "next/image";
import { useEffect, useState } from "react";

const Withdraw = () => {

	const [amount, setAmount] = useState(0);
	const [accId, setAccId] = useState("");
	const [accBalance, setaccBalance] = useState(0.004);
	const [effAccBalance, setEffAccBalance] = useState(0.004);

	useEffect(()=> {
		setEffAccBalance(parseFloat(accBalance) + parseFloat(amount));
		console.log("sum:", accBalance + amount);
	}, [amount]);
	
	const handleWithdrawal = (eve) => {
		eve.preventDefault();
		console.log("Amount Withrawed:", amount);
	}

    return <>
        <Head>
			<title>Deposit Money: Bit Finance Bank</title>
			<meta name="description" content="Withdraw money " />
			<meta name="viewport" content="width=device-width, initial-scale=1" />
		</Head>
        <main>
			<div className="vw-100 vh-100 flex flex-column border-0 blue-bg">
                <Image className="mb-3" src={"/logo.png"} width={140} height={140} alt="logo" />
                <form className="bg-white p-5 rounded shadow text-dark"  onSubmit={handleWithdrawal}>
                    <h4 className="text-center mb-4">Deposit Money</h4>
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
                            <input type="number" id="amount" min="0" step="0.0001" value={amount} onChange={e => setAmount(e.target.value)} />
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