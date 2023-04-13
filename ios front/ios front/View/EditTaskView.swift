//
//  EditTaskView.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 06.04.2023.
//

import SwiftUI

struct EditTaskView: View {
    var onEdit: (TaskModel) -> ()
    var onDelete: (TaskModel) -> ()
    
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTask: TaskModel?
    @Binding var tasks: [TaskModel]
    
    @State private var userID: String = ""
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskCost: Int = 0
    @State private var taskCategory: String = ".general"
    @State private var isDone = false
    @State private var isOverdue = false
    @State private var confirmationShown = false
    
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
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .contentShape(Rectangle())
                    }
                    
                    Spacer()
                    
                    // Кнопка удаления задачи
                    Button (
                        role: .destructive,
                        action: {
                            confirmationShown = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                                .contentShape(Rectangle())
                                .frame(minWidth: 50)
                                .font(.system(size: 25))
                        }
                        .confirmationDialog (
                            "Вы действительно хотите удалить задачу?",
                            isPresented: $confirmationShown,
                            titleVisibility: .visible) {
                                Button("Да") {
                                    withAnimation {
                                        let task = TaskModel(id: selectedTask!.id, userID: userID, title: taskName, time: taskDate.toString("dd LLLL yy HH:ss"), cost: taskCost, description: taskDescription, category: taskCategory, isDone: isDone, isOverdue: isOverdue)
                                        onDelete(task)
                                        dismiss()
                                    }
                                }
                                Button("Нет", role: .cancel) { }
                            }
                            .disabled(isOverdue || taskDate < Date())
                            .opacity(isOverdue || taskDate < Date() ? 0.6 : 1)
                    }
            
                Text("Редактирование задачи")
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
                    .disabled(isOverdue || taskDate < Date())
                    .opacity(isOverdue || taskDate < Date() ? 0.6 : 1)
                
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
                                .disabled(isOverdue || taskDate < Date())
                                .opacity(isOverdue || taskDate < Date() ? 0.6 : 1)
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
                                .disabled(isOverdue || taskDate < Date())
                                .opacity(isOverdue || taskDate < Date() ? 0.6 : 1)
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
                    .disabled(isOverdue || taskDate < Date())
                    .opacity(isOverdue || taskDate < Date() ? 0.6 : 1)
                
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .frame(height: 1)
                
                Text("Стоимость")
                    .foregroundColor(.gray)
                
                TextField("Стоимость задачи", value: $taskCost, formatter: numFormatter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 2)
                    .disabled(isOverdue || taskDate < Date())
                    .opacity(isOverdue || taskDate < Date() ? 0.6 : 1)
                
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
                                    .fill(category.color.opacity(0.45))
                            }
                            .foregroundColor(category.color)
                            .contentShape(Rectangle())
                            .disabled(isOverdue || taskDate < Date())
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
                    .disabled(isOverdue || taskDate < Date())
                    .opacity(isOverdue || taskDate < Date() ? 0.6 : 1)
                
                Button {
                    let task = TaskModel(id: selectedTask!.id, userID: userID, title: taskName, time: taskDate.toString("dd MM yyyy HH:mm"), cost: taskCost, description: taskDescription, category: taskCategory, isDone: isDone, isOverdue: isOverdue)
                    onEdit(task)
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
                .disabled(taskName == "" || animate || isOverdue || taskDate < Date())
                .opacity(taskName == "" || isOverdue || taskDate < Date() ? 0.6 : 1)
            }
            .padding(15)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear(){
            userID = selectedTask?.userID ?? ""
            taskName = selectedTask?.title ?? ""
            taskDescription = selectedTask?.description ?? ""
            taskDate = selectedTask?.time.toDate("dd MM yy HH:mm") ?? .init()
            taskCost = selectedTask?.cost ?? 0
            taskCategory = selectedTask?.category ?? ".general"
            isDone = selectedTask?.isDone ?? false
            isOverdue = selectedTask?.isOverdue ?? false
            
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

//struct EditTaskView_Previews: PreviewProvider {
//    @State static var task1: TaskModel? = TaskModel()
//    static var previews: some View {
//        EditTaskView (onEdit: {
//            task in
//        }, selectedTask: $task1)
//    }
//}


