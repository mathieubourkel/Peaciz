import React from "react";
import "./styles/Home.css";

function Home() {
    return (
        <div className='home'>
            <div className='home-text'>
                <h2>Share the Pieces of</h2>
                <h1>your music History</h1>
            </div>
            <div className="home-buttons">
                <button><h3>Connect As Artist</h3></button>
                <button><h3>Connect As Fan</h3></button>
            </div>
        </div>
    )
}

export default Home;