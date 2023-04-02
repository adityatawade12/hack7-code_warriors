import Head from "next/head";
import Image from "next/image";
import { useRouter } from "next/router";
import { useState } from "react";

const Login = () => {

    const [hiddenPass, setHiddenPass] = useState(true);
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");

    const router = useRouter();

    const handleLogin = (eve) => {
        eve.preventDefault();

        let data = {
            "email": email,
            "password": password
        }
        console.log("Data:", data);
        router.push("/home");
    }

    return <>
        <Head>
			<title>Login: Bit Finance Bank</title>
			<meta name="description" content="Login to your bank account" />
			<meta name="viewport" content="width=device-width, initial-scale=1" />
		</Head>
        <main>
            <div className="vw-100 vh-100 flex flex-column border-0 blue-bg">
                <Image className="mb-3" src={"/logo.png"} width={140} height={140} alt="logo" />

                <form className="bg-white p-5 rounded shadow text-dark" onSubmit={handleLogin}>
                    <h4 className="text-center mb-4">LOGIN</h4>
                    <div className="mb-3 px-3 mx-3">
                        <label htmlFor="email" className="form-label w-100">Email</label>
                        <div className="ui left icon input w-100">
                            <i aria-hidden="true" className="user icon"></i>
                            <input type="email" id="email" placeholder="name@example.com" onChange={(e)=> setEmail(e.target.value)} />
                        </div>
                    </div>
                    <div className="mb-3 px-3 mx-3">
                        <label htmlFor="password" className="form-label w-100">Password</label>
                        <div className="ui left icon input action w-100">
                            <i aria-hidden="true" className="fas fa-lock icon"></i>
                            <input type={hiddenPass ? "password" : "text"} id="password" placeholder="name@example.com" onChange={(e)=> setPassword(e.target.value)} />
                            <button className="ui left icon button" style={{ width: "3em" }} onClick={(e)=> {
                                e.preventDefault();
                                setHiddenPass(!hiddenPass);
                            }}><i aria-hidden="true" className={"far " + (hiddenPass ? "fa-eye-slash" : "fa-eye")}></i></button>
                        </div>
                    </div>
                    <div className="flex w-100 mt-4">
                        <button className="ui blue-btn button" type="submit">Login</button>
                    </div>
                </form>
            </div>
        </main>
    </>
}

export default Login;