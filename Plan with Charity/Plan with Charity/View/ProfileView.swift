//
//  ProfileView.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    @State var organizations: [Organization] = getOrganizations()
    @Environment(\.self) private var env
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.time, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    @StateObject var taskModel: TaskModel = .init()
    
    @State var sum: Int = UserDefaults.standard.integer(forKey: "sum")
    @State var passedSum: Int = UserDefaults.standard.integer(forKey: "passed")
    @State var searchText: String = ""
    @State private var confirmationShown = false

    @Environment(\.dismiss) private var dismiss
    
    @State var name: String = UserDefaults.standard.string(forKey: "username") ?? ""
 
    @State private var isEditing = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("ProfilePhoto")
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130, height: 130)
                        .padding(20)
                        .padding(.top, -80)

                    
                    HStack {
                        Text(name)
                            .font(.title)
                            .fontWeight(.bold)
                            .offset(x: 5, y: -10)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                            .offset(x: 5, y: -10)
                    }

                    Text("Переведено на благотворительность:   \(self.passedSum)")
                        .font(.caption)

                    Text("Накопленная сумма:   \(self.sum)")
                        .font(.title2)
                        .padding()

                    HStack {
                        Spacer()

                        // Кнопка сброса накопленной суммы
                        Button (
                            role: .destructive,
                            action: {
                                confirmationShown = true
                            }) {
                                Text("Сбросить сумму")
                                    .font(.system(size: 15))
                            }
                            .confirmationDialog (
                                "Вы действительно хотите сбросить накопленную сумму?",
                                isPresented: $confirmationShown,
                                titleVisibility: .visible) {
                                    Button("Да") {
                                        withAnimation {
                                            UserDefaults.standard.set(0, forKey: "sum")
                                            self.sum = 0
                                        }
                                    }
                                    Button("Нет", role: .cancel) { }
                                }
                                .disabled(self.sum == 0)
                                .opacity(self.sum == 0 ? 0.6 : 1)

                    }
                    .padding(.horizontal, 55)
                    .padding(.vertical, 2)

                    SearchBar(text: $searchText)
                        .padding(.top, 0)

                    if organizations.count == 0 {
                        Text("Идёт загрузка благотворительных организаций...")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(organizations.filter({ searchText == "" ? true : $0.name.contains(searchText) })) { organization in
                                CardView(name: organization.name, description: organization.description, urlPay: organization.urlPay, sum: self.sum)
                            }
                        }
                    }
                    .padding()

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                Text("* Нажимая на кнопку денежного перевода (₽) в правом верхнем углу выбранной благотворительной организации, вы попадёте на официальный ресурс данной благотворительной организации, где сможете больше познакомиться с её деятельностью и, если решите выбрать её для перевода своей накопленной суммы, то там же сможете совершить денежный перевод любым удобным способом")
                    .font(.caption)
                    .padding()

                Text("** Нажимая на кнопку 'Подтвердить денежный перевод', вы подтверждаете, что совершили денежный перевод на указанную сумму. После этого ваша накопленная сумма обнулится")
                    .font(.caption)
                    .padding()
                
                HStack {
                    if isEditing {
                        TextField("Сменить имя...", text: $name)
                            .font(.title2)
                            .padding()
                    } else {
                        Text("Сменить имя...")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                self.isEditing = true
                            }
                            .padding()
                        
                        Spacer()
                    }
                    
                    if isEditing {
                        Button(action: {
                            UserDefaults.standard.set(name, forKey: "username")
                            self.isEditing = false
                        }) {
                            Text("Сохранить")
                        }
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                        .padding()
                    }
                }
                
                Button (
                    role: .destructive,
                    action: {
                        confirmationShown = true
                    }) {
                        Text("Удалить все задачи")
                    }
                    .confirmationDialog (
                        "Вы действительно хотите удалить все задачи?",
                        isPresented: $confirmationShown,
                        titleVisibility: .visible) {
                            Button("Да") {
                                clearDatabase()
                            }
                            Button("Нет", role: .cancel) { }
                        }
                        .padding(.bottom, 50)
            }
        }
        .onAppear() {
            // Подсчёт накопленной суммы
            for task in tasks {
                if !task.isOverdue && !task.isDone && task.time!.toDate("dd MM yy HH:mm") < Date() {
                    
                    taskModel.editTask = task
                    taskModel.setupTask()
                    
                    taskModel.isOverdue = true
                    taskModel.addTask(context: env.managedObjectContext)
                    var res = UserDefaults.standard.integer(forKey: "sum") ?? 0
                    res += Int(task.cost)
                    self.sum += Int(task.cost)
                    UserDefaults.standard.set(res, forKey: "sum")
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { output in
        })
    }
    
    func clearDatabase() {
        for task in tasks {
            taskModel.editTask = task
            taskModel.setupTask()
            if let editTask = taskModel.editTask {
                env.managedObjectContext.delete(editTask)
                try? env.managedObjectContext.save()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


