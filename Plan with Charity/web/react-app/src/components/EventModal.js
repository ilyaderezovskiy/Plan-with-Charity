import React, { useContext, useState, useEffect, useRef } from "react";
import GlobalContext from "../context/GlobalContext";
import Switch from '@mui/material/Switch';
import TextField from "@mui/material/TextField";
import FormControlLabel from '@mui/material/FormControlLabel';
import InputAdornment from '@mui/material/InputAdornment';
import dayjs, { locale } from "dayjs";

const labelsClasses = [
  "indigo",
  "gray",
  "yellow",
  "orange",
  "purple",
  "green",
  "red",
];

export default function EventModal() {
  const {
    setShowEventModal,
    daySelected,
    dispatchCalEvent,
    selectedEvent,
  } = useContext(GlobalContext);

  const [title, setTitle] = useState(
    selectedEvent ? selectedEvent.title : ""
  );
  const [description, setDescription] = useState(
    selectedEvent ? selectedEvent.description : ""
  );
  const [cost, setCost] = useState(
    selectedEvent ? selectedEvent.cost : ""
  );
  const [selectedLabel, setSelectedLabel] = useState(
    selectedEvent
      ? (selectedEvent.status? "green":
      ((labelsClasses.slice(0, 5).find((lbl) => lbl === selectedEvent.label))? labelsClasses.slice(0, 5).find((lbl) => lbl === selectedEvent.label): labelsClasses[0])):
      labelsClasses[0]
  );

//   var d = new Date();
//   d.setHours(0,0,0,0);
//   // console.log(daySelected.valueOf())
//   // console.log(d.getTime())


  const [isComplited, setComplited] = useState(
    selectedEvent ? selectedEvent.status : false
  );
  
  const [hour, setHour] = useState(
    selectedEvent? selectedEvent.hour: "0"
  );
  const [mins, setMins] = useState(
    selectedEvent? selectedEvent.mins: "0"
  );
  const min = 0;
  const max = 23;
  const min2 = 0;
  const max2 = 59;

  function handleSubmit(e) {
    e.preventDefault();
    const calendarEvent = {
      title,
      description,
      label: selectedLabel,
      day: daySelected.valueOf(),
      cost,
      hour,
      mins,
      status: isComplited,
      id: selectedEvent ? selectedEvent.id : Date.now(),
    };
    if (selectedEvent) {
      dispatchCalEvent({ type: "update", payload: calendarEvent });
    } else {
      dispatchCalEvent({ type: "push", payload: calendarEvent });
    }

    setShowEventModal(false);
  }
  return (
    <div className="h-screen w-full fixed left-0 top-0 flex justify-center items-center">
      <form className="bg-white rounded-lg shadow-2xl w-2/4">
        <header className="bg-gray-300 px-4 py-2 flex justify-between items-center">
          <span className="material-icons-outlined text-gray-500">
            drag_handle
          </span>
          <div>
            {selectedEvent && (
              <span
                onClick={() => {
                  if (window.confirm("Вы действительно хотите удалить задачу?")) {
                    dispatchCalEvent({
                      type: "delete",
                      payload: selectedEvent,
                    });
                    setShowEventModal(false);
                  }
                }}
                className="material-icons-outlined text-gray-500 cursor-pointer"
              >
                delete
              </span>
            )}
            <button onClick={() => setShowEventModal(false)}>
              <span className="material-icons-outlined text-gray-500 ml-4">
                close
              </span>
            </button>
          </div>
        </header>
        <div className="p-5">
          <div className="grid grid-cols-1/5 items-end gap-y-7">
            <div></div>
            <input
              type="text"
              name="title"
              placeholder="Добавить название"
              value={title}
              required
              className="pt-3 border-0 text-gray-600 text-xl font-semibold pb-2 w-full border-b-2 border-gray-200 focus:outline-none focus:ring-0 focus:border-blue-500"
              onChange={(e) => setTitle(e.target.value)}
            />

            <div className="flex gap-x-2 mt-5">
            <span className="material-icons-outlined text-gray-400 mt-4">
                schedule
            </span>

            <div className="flex gap-x-2 ml-5">
      <TextField
        fullWidth
        type="number"
        inputProps={{ min, max }}
        InputProps={{
          endAdornment: <InputAdornment position="start">ч.</InputAdornment>,
        }}
        defaultValue="00"
        value={hour}
        onChange={(e) => {
          var value = parseInt(e.target.value, 10);

          if (value > max) value = max;
          if (value < min) value = min;

          setHour(value);
        }}
        variant="outlined"
      />
      
    </div>

    <div>
    <TextField
        type="number"
        inputProps={{ min2, max2 }}
        InputProps={{
          endAdornment: <InputAdornment position="start">мин.</InputAdornment>,
        }}
        defaultValue="00"
        value={mins}
        onChange={(e) => {
          var value = parseInt(e.target.value, 10);

          if (value > max2) value = max2;
          if (value < min2) value = min2;

          setMins(value);
        }}
        variant="outlined"
      />
    </div>
            <p className="flex gap-x-2 ml-2 mt-4 h-46"> {daySelected.format("DD MMMM YYYY")}</p>
            </div>

            <div className="flex gap-x-2 mt-1">
            <span className="material-icons-outlined text-gray-400 mt-4">
              segment
            </span>

            <input
              type="text"
              name="description"
              placeholder="Добавить описание"
              value={description}
              required
              className="pt-3 ml-5 border-0 text-gray-600 pb-2 w-full border-b-2 border-gray-200 focus:outline-none focus:ring-0 focus:border-blue-500"
              onChange={(e) => setDescription(e.target.value)}
            />
            </div>

            <div className="flex gap-x-2">
            <span className="material-icons-outlined text-gray-400 mt-4">
                currency_ruble
            </span>

            <input
              type="number"
              name="cost"
              placeholder="0"
              value={cost}
              required
              className="pt-3 ml-5 border-0 text-gray-600 pb-2 w-full border-b-2 border-gray-200 focus:outline-none focus:ring-0 focus:border-blue-500"
              onChange={(e) => setCost(e.target.value)}
            />
            </div>

            <div className="flex gap-x-2 mt-4">
            <span className="material-icons-outlined text-gray-400">
              bookmark_border
            </span>

              {labelsClasses.slice(0, 5).map((lblClass, i) => (
                <span
                  key={i}
                  onClick={() => setSelectedLabel(lblClass)}
                  className={`bg-${lblClass}-500 w-6 h-6 rounded-full flex items-center justify-center cursor-pointer ml-4`}
                >
                  {selectedLabel === lblClass && (
                    <span className="material-icons-outlined text-white text-sm">
                      check
                    </span>
                  )}
                </span>
              ))}
            </div>
          </div>
        </div>
        <footer className="flex border-t p-3">
          <FormControlLabel
            sx={{
            display: 'block',
            }}
            control={
              <Switch
                checked={isComplited}
                onChange={() => setComplited(!isComplited)}
                name="status"
                color="primary"
              />
            }
            label={isComplited? "Выполнено": "Не выполнено"}
          />

          <div class="hidden:none lg:flex lg:flex-1 lg:justify-end">
            <button
              type="submit"
              onClick={handleSubmit}
              className="bg-blue-500 hover:bg-blue-600 px-6 py-2 rounded text-white lg:justify-end"
            >
              Сохранить
            </button>
          </div>
        </footer>
      </form>
    </div>
  );
}