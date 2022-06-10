import { Link } from "react-router-dom";
import React from 'react';

function Nav2({contracts, state}) {

    return(
        
        <div>Welcome on Peaciz<h1>You are logged : {state.accounts}
        <br></br>your balance is : {state.balance}</h1></div>
    )
}

export default Nav2;