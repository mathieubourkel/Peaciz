import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { useState, useEffect } from "react";
import { ethers } from "ethers";
import FactoryAbi from '../contractsData/Factory.json';
import FactoryAddress from '../contractsData/Factory-address.json';
import ArtistsAbi from '../contractsData/Artists.json';
import ArtistsAddress from '../contractsData/Artists-address.json';
import Nav from "./Header/Nav";
import Nav2 from "./Header/Nav2";
import About from "./Main/About";
import Explore from "./Main/Explore";
import Swap from "./Main/Swap";
import Home from "./Main/Home";
import Trending from "./Main/Trending";
import Marketplace from "./Main/Marketplace/Marketplace";
import MyFanCollections from "./Main/Fan/MyFanCollections";
import FanCollection from "./Main/Fan/FanCollection";
import Item from "./Main/Fan/Item/Item";
import Additional from "./Main/Fan/Item/Additional";
import Merchandising from "./Main/Fan/Item/Merchandising";
import Music from "./Main/Fan/Item/Music";
import Pictures from "./Main/Fan/Item/Pictures";
import Show from "./Main/Fan/Item/Show";
import Social from "./Main/Fan/Item/Social";
import MyArtistCollections from "./Main/Artist/MyArtistCollections";
import MyProfile from "./Main/Artist/MyProfile";
import ArtistCollection from "./Main/Artist/ArtistCollection";
import CreateCollection from "./Main/Artist/CreateCollection";
import Footer from "./Footer/Footer";
import MusicFooter from "./Footer/MusicFooter";

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
            <Routes>
                <Route path="/" element={<Home contracts={contracts} state={state}/>} />
                <Route path="/trending" element={<Trending contracts={contracts} state={state}/>} />
                <Route path="/explore" element={<Explore contracts={contracts} state={state}/>} />
                <Route path="/about" element={<About contracts={contracts} state={state}/>} />
                <Route path="/marketplace" element={<Marketplace contracts={contracts} state={state}/>} />
                <Route path="/swap" element={<Swap contracts={contracts} state={state}/>} />
                <Route path="/artist" element={<MyArtistCollections contracts={contracts} state={state}/>} />
                <Route path="/artist/collection" element={<ArtistCollection contracts={contracts} state={state}/>} />
                <Route path="/artist/create-collection" element={<CreateCollection contracts={contracts} state={state}/>} />
                <Route path="/artist/my-profile" element={<MyProfile contracts={contracts} state={state}/>} />
                <Route path="/fan" element={<MyFanCollections contracts={contracts} state={state}/>} />
                <Route path="/fan/collection" element={<FanCollection contracts={contracts} state={state}/>} />
                <Route path="/fan/item" element={<Item contracts={contracts} state={state}/>} />
                <Route path="/fan/item/additional" element={<Additional contracts={contracts} state={state}/>} />
                <Route path="/fan/item/merchandising" element={<Merchandising contracts={contracts} state={state}/>} />
                <Route path="/fan/item/music" element={<Music contracts={contracts} state={state}/>} />
                <Route path="/fan/item/pictures" element={<Pictures contracts={contracts} state={state}/>} />
                <Route path="/fan/item/show" element={<Show contracts={contracts} state={state}/>} />
                <Route path="/fan/item/social" element={<Social contracts={contracts} state={state}/>} />
                <Route path="*" element={<Navigate to="/" />} />
            </Routes>
        <MusicFooter />
        <Footer />
      </BrowserRouter>
    );
  }

export default App;