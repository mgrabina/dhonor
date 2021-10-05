import React from "react";
import { DrizzleContext } from "@drizzle/react-plugin";
import { Drizzle } from "@drizzle/store";
import drizzleOptions from "./drizzleOptions";
import MyComponent from "./MyComponent";
import "./App.css";
import { Provider as StyletronProvider, DebugEngine } from "styletron-react";
import { Client as Styletron } from "styletron-engine-atomic";

const engine = new Styletron();

const drizzle = new Drizzle(drizzleOptions);
const theme = {
  colors: {
    primary: 'tomato',
    accent: 'yellow',
  },
};
const debug =
  process.env.NODE_ENV === "production" ? void 0 : new DebugEngine();

const App = () => {
  return (
    
    <DrizzleContext.Provider drizzle={drizzle}>
      <DrizzleContext.Consumer>
        {drizzleContext => {
          const { drizzle, drizzleState, initialized } = drizzleContext;

          if (!initialized) {
            return "Loading..."
          }

          return (
            <StyletronProvider value={engine} debug={debug} debugAfterHydration>

            <MyComponent drizzle={drizzle} drizzleState={drizzleState} /> 
             </StyletronProvider>

          )
        }}
      </DrizzleContext.Consumer>
    </DrizzleContext.Provider>


  );
}

export default App;
