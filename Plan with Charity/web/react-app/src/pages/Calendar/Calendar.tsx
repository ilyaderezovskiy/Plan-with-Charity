import React, { useState, useContext, useEffect } from "react";
import Typography from "@mui/material/Typography";
import CalendarHeader from "../../components/CalendarHeader";
import Sidebar from "../../components/Sidebar";
import Month from "../../components/Month";
import { getMonth } from "../../utils";
import GlobalContext from "../../context/GlobalContext";
import EventModal from "../../components/EventModal";

export const Calendar: React.FC = ({ navigation }) => {

    const [currentMonth, setCurrentMonth] = useState(getMonth());

    const { monthIndex, showEventModal } = useContext(GlobalContext);

  useEffect(() => {
    setCurrentMonth(getMonth(monthIndex));
  }, [monthIndex]);

    return (
        <React.Fragment>
        {showEventModal && <EventModal />}

        <div className="h-screen flex flex-col" style={{backgroundColor:"white"}}>
        <CalendarHeader navigation={navigation} />
        <div className="flex flex-1">
          <Sidebar />
          <Month month={currentMonth} />
        </div>
      </div>
      </React.Fragment>
    )
}