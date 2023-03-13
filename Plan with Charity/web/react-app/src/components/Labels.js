import React, { useContext } from "react";
import GlobalContext from "../context/GlobalContext";

export default function Labels() {
  const { labels, updateLabel } = useContext(GlobalContext);
  return (
    <React.Fragment>
        <p className="text-gray-500 font-bold mt-10"> Категории </p>

        {labels.map(({ label: lbl, checked }, idx) => (
        <label key={idx} className="items-center mt-2 block">
            <div className="flex gap-x-2">
          <input
            type="checkbox"
            checked={checked}
            onChange={() =>
              updateLabel({ label: lbl, checked: !checked })
            }
            className={`form-checkbox h-5 w-5 bg-${lbl}-400 rounded focus:ring-0 cursor-pointer`}
          />
            
          {/* <span className="ml-2 text-gray-700 capitalize">{lbl}</span> */}
          <span
            className={`bg-${lbl}-500 w-6 h-6 rounded-full flex items-center justify-center cursor-pointer ml-4`}
            >
          </span>
          </div>
        </label>
      ))}
    </React.Fragment>
  );
}