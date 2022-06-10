import { Link } from "react-router-dom";
import React from 'react';
import Logo from "../../resource/logo.png";

function Nav({contracts, state}) {

    return(
        
        <nav className='navbar'> 
            <div className='navbar-logo'>
                <Link to="/">
                    <img src={Logo} alt="logo" className='navbar-logo-image' />
                </Link>  
            </div>
            <ul className='navbar-list'>
                <li>
                    <Link to="/about">About</Link>
                </li>
                <li>
                    <Link to="/explore">Explore</Link>
                </li>
                <li>
                    <Link to="/trending">Trending</Link>
                </li>
                <li>
                    <Link to="/marketplace">Marketplace</Link>
                </li>
                <li>
                    <Link to="/swap">Swap</Link>
                </li>
            </ul>
        </nav>
    )
}

export default Nav;