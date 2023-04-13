//
//  CustomDatePicker.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 06.04.2023.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    @Binding var tasks: [TaskModel]
    @Binding var user: User?
    let email: String
    @State var currentMonth: Int = 0
    @State var selectedTask: TaskModel?
    @State private var editTask: Bool = false
    
    @State var shouldPresentSheet = false
    
    var body: some View {
        VStack(spacing: 35) {
            
            let days: [String] = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extraDate()[1].capitalizingFirstLetter())
                        .font(.title3)
                }
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button {
                    print(tasks.count)
                    withAnimation {
                        currentMonth = 0
                    }
                } label: {
                    Text("Сегодня")
                }
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .frame(minWidth: 30)
                }
                
                // Кнопка личного кабинета пользователя
                Button {
                    shouldPresentSheet.toggle()
                } label: {
                    Image(systemName: "person.crop.circle")
                        .contentShape(Rectangle())
                        .frame(minWidth: 30)
                        .font(.system(size: 45))
                }
                .cornerRadius(10)
                .sheet(isPresented: $shouldPresentSheet, content: {
                    ProfileView(user: $user, tasks: $tasks, email: "email")
                })
                
            }
            .padding(.horizontal)
            
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            // Заполнение календаря числами с отметками о наличии задач
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        .background(
                            Capsule()
                                .fill(.pink)
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                            
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            
            // Отображение задач пользователя
            VStack(spacing: 15) {
                Text("Задачи")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 20)
                if tasks.first(where: { task in
                    return isSameDay(date1: task.time.toDate("dd MM yy HH:mm"), date2: currentDate)
                }) != nil {
                    // Фильтрация задач по выбранному дню
                    ForEach(tasks.filter { task in
                        if isSameDay(date1: task.time.toDate("dd MM yy HH:mm"), date2: currentDate) {
                            return true
                        } else {
                            return false
                        }
                    }) { task in
                        VStack(alignment: .leading, spacing: 10) {
                            
                            // Отображение информации о задаче
                            HStack {
                                Text((task.time.toDate("dd MM yy HH:mm")).toString("HH:mm")
                                )
                                
                                Text(task.isDone ? "Выполнено!" : "")
                                
                                Spacer()
                                
                                Button {
                                    selectedTask = task
                                    selectedTask?.id = task.id
                                    editTask.toggle()
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 30))
                                        .foregroundColor(.black)
                                        .padding(5)
                                }
                            }
                            
                            Text(task.title)
                                .font(.title2.bold())
                            
                            Text(task.description)
                                .font(.title3)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            task.isOverdue || (task.time.toDate("dd MM yy HH:mm") < Date() && task.isDone == false) ? Color.red.opacity(0.5).cornerRadius(10):
                                getColor(category: task.category).color
                                .opacity(0.5)
                                .cornerRadius(10)
                        )
                    }
                } else {
                    Text("Актуальных задач нет")
                }
            }
            .padding()
        }
        .onChange(of: currentMonth) { newValue in
            currentDate = getCurrentMonth()
        }
        .fullScreenCover(isPresented: $editTask) {
            var taskID: String = ""
            EditTaskView (onEdit: { task in
                if let id = tasks.firstIndex(where: { $0.id == task.id }) {
                    tasks[id] = task
                    Task {
                        do {
                            try await NetworkService.shared.editTask(task: task)
                        } catch {
                            print("Error")
                        }
                    }
                }
            }, onDelete: {
                task in
                if let id = tasks.firstIndex(where: { $0.id == task.id }) {
                    taskID = tasks[id].id
                    tasks.remove(at: id)
                }
                NetworkService.shared.deleteTask(taskID: taskID)
            }, selectedTask: $selectedTask, tasks: $tasks)
        }
    }
    
    // Отображение задач пользователя в виде карточек
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                if let task = tasks.first(where: { task in
                    
                    return isSameDay(date1: task.time.toDate("dd MM yy HH:mm"), date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: task.time.toDate("dd MM yy HH:mm"), date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(date1: task.time.toDate("dd MM yy HH:mm"), date2: currentDate) ? .white : .pink)
                        .frame(width: 8, height: 8)
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }
    
    // Сравнение дат
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, equalTo: date2, toGranularity: .day)
    }
    
    // Получение текущей даты
    func extraDate() -> [String] {
        let date = currentDate.toString("YYYY LLLL")
        
        return date.components(separatedBy: " ")
    }
    
    // Получение текущего месяца
    func getCurrentMonth() -> Date {
        
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    // Получение чисел для заполнения календаря
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days =  currentMonth.getAllDates().compactMap { date ->
            DateValue in
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        var firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date()) - 1
        if firstWeekday == 0 {
            firstWeekday = 7
        }
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
    func getColor(category: String) -> Category {
        if category == ".general" {
            return Category.general
        } else if category == ".bug" {
            return Category.bug
        } else if category == ".idea" {
            return Category.idea
        } else if category == ".modifiers" {
            return Category.modifiers
        } else if category == ".challenge" {
            return Category.challenge
        } else {
            return Category.coding
        }
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    @State static var currentDate: Date = Date()
    @State static var tasks: [TaskModel] = []
    @State static var user: User? = User(id: "fgjh", username: "hkbkh", sum: 100)
    @State static var email: String = ""
    static var previews: some View {
        CustomDatePicker(currentDate: $currentDate, tasks: $tasks, user: $user, email: email)
    }
}

extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
    
    func toDate(_ format: String) -> Date {
        let formatter = DateFormatter()
        //formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
}

extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

