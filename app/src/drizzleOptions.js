import Web3 from "web3";
import Dhonor from "./contracts/Dhonor.json";

const options = {
  web3: {
    block: false,
    customProvider: new Web3("ws://localhost:7545"),
  },
  contracts: [Dhonor],
  events: {
  },
};

export default options;
