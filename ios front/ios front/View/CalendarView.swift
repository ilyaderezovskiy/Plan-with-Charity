//
//  CalendarView.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 06.04.2023.
//

import SwiftUI

struct CalendarView: View {
    @Binding var user: User?
    let email: String
    @State var currentDate: Date = Date()
    @State private var addNewTask: Bool = false
    @State private var tasks: [TaskModel] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // Отображение кастомизированного календаря с задачами пользователя
                CustomDatePicker(currentDate: $currentDate, tasks: $tasks, user: $user, email: email)
            }
            .padding(.vertical)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                // Кнопка добавления задачи
                Button {
                    addNewTask.toggle()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                        Text("Добавить задачу")
                            .fontWeight(.bold)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal)
                .frame(maxWidth: 230)
                .foregroundColor(.white)
                .background(Color("Blue"), in: Capsule())
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .foregroundColor(.white)
        }
        .fullScreenCover(isPresented: $addNewTask) {
            AddTaskView (onAdd: { task in
                tasks.append(task)
                Task {
                    do {
                        try await NetworkService.shared.addTask(task: task)
                    } catch {
                        print("Error")
                    }
                }
            }, user: $user, selectedDate: $currentDate)
        }
        .onAppear() {
            tasks = NetworkService.shared.getTasks(userID: user!.id)
            UserNotificationsService.instance.requestAuthorization(userID: user!.id)
            UserNotificationsService.instance.scheduleNotification()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { output in
            UIApplication.shared.applicationIconBadgeNumber = 0
        })
    }
}

struct CalendarView_Previews: PreviewProvider {
    @State static var user: User? = User(id: "1", username: "Ilya", sum: 100)
    @State static var email: String = ""
    static var previews: some View {
        CalendarView(user: $user, email: email)
    }
}



