// connect page and components
import React, {useContext, createContext} from 'react';
import {useAddress, useContract, useMetamask, useContractWrite} from '@thirdweb-dev/react';
import {ethers} from 'ethers';

const StateContext = createContext();

export const StateContextProvider = ({children}) => {
    // Smart Contract address from thirdweb
    const {contract} = useContract('0xe069E8483e3d701571e8d4AEFCbD02840c1401e0');
    const {mutsteAsync: createCampaign} = useContractWrite(contract, 'createCampaign'); // pass all parameters

    const address = useAddress();
    const connect = useMetamask(); // to connect with smart wallet

    const publishCampaign = async (form) => {
        try {
            const data = await createCampaign([
                address, // owner
                form.title,
                form.description,
                form.target,
                new Date(form.deadline).getTime(),
                form.image
            ])
            console.log("Contract call succeeded", data)
        } catch (error) {
            console.log("Contract call failed", error)
        }
    }

    return (
        <StateContext.Provider
        value = {{
            address,
            contract,
            connect,
            createCampaign: publishCampaign // rename publishCampaign to createCampaign
        }}
        >
            {children}
        </StateContext.Provider>
    )
}

export const useStateContext = () => useContext(StateContext);