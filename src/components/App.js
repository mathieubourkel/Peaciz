import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { useState, useEffect } from "react";
import { ethers } from "ethers";
import FactoryAbi from '../contractsData/Factory.json';
import FactoryAddress from '../contractsData/Factory-address.json';
import ArtistsAbi from '../contractsData/Artists.json';
import ArtistsAddress from '../contractsData/Artists-address.json';
import Nav from "./Header/Nav";
import Nav2 from "./Header/Nav2";

function App() {

    // Variables
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const factoryInstance = new ethers.Contract(FactoryAddress.address, FactoryAbi.abi, signer);
    const artistsInstance = new ethers.Contract(ArtistsAddress.address, ArtistsAbi.abi, signer);
   
    // States
    const [contracts, setContracts] = useState({artistsContract: artistsInstance, factoryContract: factoryInstance});
    const [state, setState] = useState({accounts: '', balance: ''});
  
    useEffect(() => {
      (async function () {
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        const getBalance = await provider.getBalance(accounts[0]);
        const balance = ethers.utils.formatEther(getBalance);
        setState({accounts: accounts[0], balance: balance})
        window.ethereum.on('chainChanged', (chainId) => {
          window.location.reload();
        })
        window.ethereum.on('accountsChanged', async function (accounts) {
          const getBalance = await provider.getBalance(accounts[0]);
          const balance = ethers.utils.formatEther(getBalance);
          setState({accounts: accounts[0], balance: balance})
        })
       }) ()}, [])
  
    // Display
    return (
      <BrowserRouter>
        <Nav contracts={contracts} state={state}/>
        <Nav2 contracts={contracts} state={state}/>
      </BrowserRouter>
    );
  }

export default App;