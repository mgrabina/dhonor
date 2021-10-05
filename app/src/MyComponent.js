import React from "react";
import { newContextComponents } from "@drizzle/react-components";

import background from "./assets/background.jpg";
import { ThemeProvider, Div, Text } from  "atomize"

const { AccountData, ContractData, ContractForm } = newContextComponents;


const theme = {
  colors: {
      primary: "purple",
      accent: 'pink'
  }
}

export default ({ drizzle, drizzleState }) => {
  // destructure drizzle and drizzleState from props
  return (
    <ThemeProvider theme={theme}>
      <Div className="App" >
      <Div bg="gray200" m="20">
        {/* <img src={logo} alt="drizzle-logo" /> */}
        <Text tag="h1">Dhonor</Text>
        <Text tag="p">
          Making a better world
        </Text>
      </Div>

      <Div className="section">
        <Text textColor="primary" tag="h2">Active Account</Text>
        <Text textColor="accent">
          <AccountData
            drizzle={drizzle}
            drizzleState={drizzleState}
            accountIndex={0}
            units="ether"
            precision={3}
          />
        </Text>
      </Div>

      <Div className="section">
        <Text tag="h2">Dhonor</Text>
        <Text tag="p">
          Donations DApp
        </Text>
        <Text tag="p">
          <strong>Manager: </strong>
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="Dhonor"
            method="manager"
          />
        </Text>
        <Text tag="p">
          <strong>Campaigns: </strong>
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="Dhonor"
            method="campaigns"
            methodArgs={[1]}
          />
        </Text>
        <ContractForm
          drizzle={drizzle}
          contract="Dhonor"
          method="createCampaign"
          sendArgs={{gasPrice: 10000000, gas: 100000}}
        />
        {/* <ContractForm drizzle={drizzle} contract="Dhonor" method="set" /> */}
      </Div>


      {/* <Div className="section">
        <Text tag="h2">SimpleStorage</Text>
        <Text tag="p">
          This shows a simple ContractData component with no arguments, along
          with a form to set its value.
        </Text>
        <Text tag="p">
          <strong>Stored Value: </strong>
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="SimpleStorage"
            method="storedData"
          />
        </Text>
        <ContractForm drizzle={drizzle} contract="SimpleStorage" method="set" />
      </Div>

      <Div className="section">
        <Text tag="h2">TutorialToken</Text>
        <Text tag="p">
          Here we have a form with custom, friendly labels. Also note the token
          symbol will not display a loading indicator. We've suppressed it with
          the <code>hideIndicator</code> prop because we know this variable is
          constant.
        </Text>
        <Text tag="p">
          <strong>Total Supply: </strong>
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="TutorialToken"
            method="totalSupply"
            methodArgs={[{ from: drizzleState.accounts[0] }]}
          />{" "}
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="TutorialToken"
            method="symbol"
            hideIndicator
          />
        </Text>
        <Text tag="p">
          <strong>My Balance: </strong>
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="TutorialToken"
            method="balanceOf"
            methodArgs={[drizzleState.accounts[0]]}
          />
        </Text>
        <h3>Send Tokens</h3>
        <ContractForm
          drizzle={drizzle}
          contract="TutorialToken"
          method="transfer"
          labels={["To Address", "Amount to Send"]}
        />
      </Div>

      <Div className="section">
        <Text tag="h2">ComplexStorage</Text>
        <Text tag="p">
          Finally this contract shows data types with additional considerations.
          Note in the code the strings below are converted from bytes to UTF-8
          strings and the device data struct is iterated as a list.
        </Text>
        <Text tag="p">
          <strong>String 1: </strong>
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="ComplexStorage"
            method="string1"
            toUtf8
          />
        </Text>
        <Text tag="p">
          <strong>String 2: </strong>
          <ContractData
            drizzle={drizzle}
            drizzleState={drizzleState}
            contract="ComplexStorage"
            method="string2"
            toUtf8
          />
        </Text>
        <strong>Single Device Data: </strong>
        <ContractData
          drizzle={drizzle}
          drizzleState={drizzleState}
          contract="ComplexStorage"
          method="singleDD"
        />
      </Div> */}
    </Div>
    </ThemeProvider>
  );
};
