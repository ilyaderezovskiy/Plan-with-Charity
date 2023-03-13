import React, { useState, useContext, useEffect } from "react";
import "./App.css";
import { getMonth } from "./utils";
import CalendarHeader from "./components/CalendarHeader";
import Sidebar from "./components/Sidebar";
import Month from "./components/Month";
import { Calendar } from "./pages/Calendar/Calendar.tsx";
import GlobalContext from "./context/GlobalContext";
import EventModal from "./components/EventModal";
import { AuthPage } from "./pages/AuthPage/AuthPage.tsx";
import { createStackNavigator, StackNavigationOptions } from "@react-navigation/stack";
import { NavigationContainer } from "@react-navigation/native";
import { Profile } from "./pages/Profile";
import { AuthForm } from "./pages/AuthPage/AuthForm/AuthForm.tsx";

const Stack = createStackNavigator();

function App() {
  const [currentMonth, setCurrentMonth] = useState(getMonth());
  const { monthIndex, showEventModal } = useContext(GlobalContext);

  useEffect(() => {
    setCurrentMonth(getMonth(monthIndex));
  }, [monthIndex]);

  return (
    <React.Fragment>
      {/* {showEventModal && <EventModal />} */}

      <NavigationContainer>
            <Stack.Navigator initialRouteName="AuthPage">
              <Stack.Screen name="AuthPage" component={AuthPage} options={ { headerShown : false }} />
              <Stack.Screen name="Calendar" component={Calendar} options={ { headerShown : false }} />
              <Stack.Screen name="Profile" component={Profile} />
            </Stack.Navigator>
        </NavigationContainer>
      {/* <div className="h-screen flex flex-col">
        <AuthPage />
        <CalendarHeader />
        <div className="flex flex-1">
          <Sidebar />
          <Month month={currentMonth} />
        </div>
      </div> */}
    </React.Fragment>
  );
}

export default App;