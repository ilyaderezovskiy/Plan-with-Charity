//
//  AddTaskView.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 06.04.2023.
//

import SwiftUI

struct AddTaskView: View {
    var onAdd: (TaskModel) -> ()
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var user: User?
    @Binding var selectedDate: Date
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskCost: Int = 0
    @State private var taskCategory: String = ".general"
    @State private var isDone = false
    @State private var isOverdue = false
    
    @State private var animateColor: Color = Category.general.color
    @State private var animate: Bool = false
    
    let numFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                }
            
                Text("Создание задачи")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                
                Text("Название")
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 15)
                
                TextField("Название задачи", text: $taskName)
                    .font(.title3)
                    .tint(.white)
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(.white.opacity(0.7))
                    .frame(height: 1)
                
                Text("Дата")
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 15)
                
                HStack(alignment: .bottom, spacing: 12) {
                    HStack(spacing: 12) {
                        Text(taskDate.toString("dd MMMM, YYYY"))
                    
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundColor(.white)
                        .overlay {
                            DatePicker("", selection: $taskDate, displayedComponents: [.date])
                                .blendMode(.destinationOver)
                                .environment(\.locale, Locale(identifier: "ru"))
                        }
                    }
                    .offset(y: -5)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                    
                    HStack(spacing: 12) {
                        Text(taskDate.toString("HH:mm"))
                    
                    Image(systemName: "clock")
                        .font(.title3)
                        .foregroundColor(.white)
                        .overlay {
                            DatePicker("", selection: $taskDate, displayedComponents: [.hourAndMinute])
                                .blendMode(.destinationOver)
                                .environment(\.locale, Locale(identifier: "ru"))
                        }
                    }
                    .offset(y: -5)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                }
                .padding(.bottom, 15)
            }
            .environment(\.colorScheme, .dark)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(15)
            .background {
                ZStack {
                    getColor(category: taskCategory).color
                    
                    GeometryReader {
                        let size = $0.size
                        Rectangle()
                            .fill(animateColor)
                            .mask {
                                Circle()
                            }
                            .frame(width: animate ? size.width * 2 : 0, height: animate ? size.height * 2 : 0)
                            .offset(animate ? CGSize(width: -size.width / 2, height: -size.height / 2) : size)
                    }
                    .clipped()
                }
                .ignoresSafeArea()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Описание")
                    .foregroundColor(.gray)
                
                TextField("Описание задачи", text: $taskDescription)
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .frame(height: 1)
                
                Text("Стоимость")
                    .foregroundColor(.gray)
                
                TextField("Стоимость задачи", value: $taskCost, formatter: numFormatter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .frame(height: 1)
                
                Text("Категория")
                
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 20), count: 6), spacing: 15) {
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        Text("")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 5)
                            .background {
                                Circle()
//                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(category.color.opacity(0.45))
                            }
                            .foregroundColor(category.color)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                guard !animate else {
                                    return
                                }
                                animateColor = category.color
                                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                                    animate = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    animate = false
                                    taskCategory = ".\(category)"
                                }
                            }
                    }
                }
                .padding(15)
                
                Toggle(isDone ? "Выполнено" : "Не выполнено", isOn: $isDone)
                
                Button {
                    let task = TaskModel(userID: user!.id, title: taskName, time: taskDate.toString("dd LL yyyy HH:mm"), cost: taskCost, description: taskDescription, category: taskCategory, isDone: isDone, isOverdue: isOverdue)
                    onAdd(task)
                    dismiss()
                } label: {
                     Text("Сохранить")
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background {
                            Capsule()
                                .fill(
                                    getColor(category: taskCategory).color
                                )
                        }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .disabled(taskName == "" || animate || taskDate < Date())
                .opacity(taskName == "" || taskDate < Date() ? 0.6 : 1)
            }
            .padding(15)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear() {
            taskDate = selectedDate
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
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

struct AddTaskView_Previews: PreviewProvider {
    @State static var user: User? = User(id: "1", username: "Ilya", sum: 100)
    @State static var selectedDate: Date = Date()
    static var previews: some View {
        AddTaskView (onAdd: {
            task in
        }, user: $user, selectedDate: $selectedDate)
    }
}

