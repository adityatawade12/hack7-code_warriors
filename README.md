

<h1 align="center"> Bit Finance </h1> <br>
<p align="center">
  <a href="https://gitpoint.co/">
    <img alt="Cover" title="Cover" src="readme-images\cover.png" width="800" height="450">
    <!-- assets\images\logo.png -->
  </a>
</p>

<p align="center">
  Crypto payments made easy
</p>

<br/>
<br/>

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Pre-Requisites](#pre-requisites)
- [Build Instructions](#build-instructions)
- [Tools Used](#tools-used)
- [Screenshots](#screenshots)
- [Acknowledgments](#acknowledgments)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction



**Cryptocurrencies** are the talk of the town. Today, we use them as a mere **tradable assets**. With the rise of Stable Coins like **USDCoin**, ever wondered that a time will come when we use cryptocurrencies as a day to day **mode of payment**? Majority of the existing cryptocurrency wallets tend to be **clunky** to operate and are developer oriented. A solution is needed to store and monitor your crypto accounts in a **user-friendly way**.  Hence, presenting our app **Bit Finance**. Our application takes the exciting world of cryptocurrency and makes it available at your fingertips. 


<!-- **Available for Android.**

<p align="center">
  <img src = "http://i.imgur.com/HowF6aM.png" width=350>
</p>

-->
## Features

A few of the things that you can do with **Bit Finance**:

- **Bit Finance** provides you a way to easily send money to anyone, at the simple scan of a **QR code**. 
- **Virtual Payment Addresses** enable users to send and receive money by just sharing a short customizable payment address, hence eliminating the need to memorize and storing the long public addresses of crypto accounts. 
- Enter the amount in **Rupees** and **Bit Finance** automatically converts the amount to the equivalent in **Ether** hence enabling you to make payments at lightening speed.
- Create **Payment Requests** to recieve money from a specific person.
- You can **store** your accounts, view your **balance** and **recent transactions** along with the **latest exchange rates**. 

<!--
<p align="center">
  <img src = "http://i.imgur.com/IkSnFRL.png" width=700>
</p>

<p align="center">
  <img src = "http://i.imgur.com/0iorG20.png" width=700>
</p>

-->

<br/>



## Pre-Requisites
- Active <a href="https://firebase.google.com/">Firebase Account</a>
- Active <a href="https://pushy.me/"> Pushy Account</a>  with API key generated
- Android Emulator / Mobile Phone with USB Debugging enabled

## Build Instructions
1. **Clone** the project
2. In the root folder, to **install project dependencies** run, `flutter pub get`
3. In the Bit Finance/lib/env folder, create a file with the name **env.g.dart** and paste the following code:
```
part of 'env.dart';

class _Env {
  static const DEV = '<RPC URL of development Ethereum blockchain>';
  static const SEP ='<RPC URL of production Ethereum blockchain>';
  static const NOTIFKEY ='<API Key of Pushy Push Notification API>';
  static const EXCHANGEKEY = "https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=inr";
}
```
4. Initializing **Firebase SDK**
    1. Install **Firebase CLI** and **Flutterfire CLI**
    2. **Login** to the CLI using command `firebase login`
    3. Run command `flutterfire configure`
    4. Choose **create a new project** and enter a new name for the project
    5. Choose **android**
    6. Go to the <a href="https://console.firebase.google.com/">Firebase Console</a>:
       1. In **Authentication** and enable **Email/Password** Authentication  
       2. Enable **Firestore Database** 
5. To **install** and **start** the app, select your target device and run the command `flutter run`

## Tools Used
- Flutter SDK
- VS Code
- Ganache
- Postman
- Android Emulator


## Screenshots
<table><tr>
<td><img alt="Cover" title="Covere" src="readme-images\img1.png"  height="500"></td> 
<td><img alt="Cover" title="Covere" src="readme-images\img2.png"  height="500"></td>
<td><img alt="Cover" title="Covere" src="readme-images\image3.png"  height="500"></td>
</tr><tr>
<td><img alt="Cover" title="Covere" src="readme-images\img4.png"  height="500"></td>
<td><img alt="Cover" title="Covere" src="readme-images\img5.png" height="500"></td>
<td><img alt="Cover" title="Covere" src="readme-images\img6.png"  height="500"></td>

</tr></table>




## Acknowledgments
- Icons used from <a href="https://www.flaticon.com/" >Flaticon</a>
- Icons used from <a href="https://icons8.com/" >Icons8</a>
- Music by <a href="https://pixabay.com/users/alexiaction-26977400/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=130563">AlexiAction</a> from <a href="https://pixabay.com/music//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=130563">Pixabay</a>


