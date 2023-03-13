import dayjs from "dayjs";
require('dayjs/locale/ru')


export function getMonth(month = dayjs().month()) {
    dayjs.locale('ru');

    month = Math.floor(month);
    const year = dayjs().year();
    const firstDayOfTheMonth = dayjs(new Date(year, month, 1)).day();
    let currentMonthCount = 1 - firstDayOfTheMonth;
    const daysMatrix = new Array(5).fill([]).map(() => {
        return new Array(7).fill(null).map(() => {
            currentMonthCount++;
        return dayjs(new Date(year, month, currentMonthCount));
    });
  });
  return daysMatrix;
}