import { ThirdwebSDK } from "@thirdweb-dev/sdk";

// If used on the FRONTEND pass your 'clientId'
const sdk = new ThirdwebSDK("goerli", {
  clientId: "3953ec172e42490c0a573a5caf743b11",
});

const contract = await sdk.getContract("0xe069E8483e3d701571e8d4AEFCbD02840c1401e0");