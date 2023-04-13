//
//  ProfileView.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 08.04.2023.
//

import SwiftUI

struct ProfileView: View {
    @Binding var user: User?
    @Binding var tasks: [TaskModel]
    @State var organizations: [Organization] = NetworkService.shared.getOrganizations()
    @State var sum: Int = 0
    @State private var confirmationShown = false
    @State private var showChangePasswordView = false
    let email: String
    @Environment(\.dismiss) private var dismiss
    
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
                        Text(user!.username)
                            .font(.title)
                            .fontWeight(.bold)
                            .offset(x: 5, y: -10)
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                            .offset(x: 5, y: -10)
                    }
                    
                    Text("Переведено на благотворительность:   1200")
                        .font(.caption)
                    
                    Text("Накопленная сумма:   \(self.user!.sum)")
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
                                            self.sum = 0
                                            Task {
                                                do {
                                                    try await NetworkService.shared.editUser(user: User(id: user!.id, username: user!.username, sum: 0))
                                                } catch {
                                                    print("Error")
                                                }
                                            }
                                            self.user!.sum = 0
                                            dismiss()
                                        }
                                    }
                                    Button("Нет", role: .cancel) { }
                                }
                                .disabled(self.user!.sum == 0)
                                .opacity(self.user!.sum == 0 ? 0.6 : 1)
                        
                    }
                    .padding(.horizontal, 55)
                    .padding(.vertical, 2)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(organizations) { organization in
                                if organization.isWorking {
                                    CardView(name: organization.name, description: organization.description, urlInfo: organization.urlInfo, urlPay: organization.urlPay, sum: self.$sum, user: self.$user)
                                }
                            }
                        }
                    }
                    .padding()

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                Text("* Нажимая на кнопку денежного перевода (₽) в правом вернем углу выбранной благотворительной оргинизации, по пападёте на официальный ресурс данной благотворительной организации, где сможете больше познакомиться с её деятельностью, и, если решите выбрать её для перевода своей накопленной суммы, то там же сможете совершить денежный перевод любым удобным способом")
                    .font(.caption)
                    .padding()
                
                Text("** Нажимая на кнопку 'Подтвердить денежный перевод' вы подтверждаете, что совершили перевод  размером не меньше вашей накопленной суммы. После этого ваша накопленная сумма обнулится")
                    .font(.caption)
                    .padding()
                
                HStack {
                    Button {
                        showChangePasswordView.toggle()
                    } label: {
                        Text("Сменить пароль")
                            .foregroundColor(.red)
                    }
                    .sheet(isPresented: $showChangePasswordView, content: {
                        PasswordChangeView(email: email, user: self.$user)
                    })
                
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear() {
            self.organizations = NetworkService.shared.getOrganizations()

            // Подсчёт накопленной суммы
            for task in tasks {
                if !task.isOverdue && !task.isDone && task.time.toDate("dd MM yy HH:mm") < Date() {
                    self.sum = self.sum + task.cost

                    if let id = tasks.firstIndex(where: { $0.id == task.id }) {
                        tasks[id].isOverdue = true
                        self.user?.sum += tasks[id].cost
                    }
                    
                Task {
                    do {
                        try await NetworkService.shared.editTask(task: TaskModel(id: task.id, userID: task.userID, title: task.title, time: task.time, cost: task.cost, description: task.description, category: task.category, isDone: task.isDone, isOverdue: true))
                    } catch {
                        print("Error")
                    }
                }
                    
                    Task {
                        do {
                            print(self.sum)
                            try await NetworkService.shared.editUser(user: User(id: user!.id, username: user!.username, sum: user!.sum))
                        } catch {
                            print("Error")
                        }
                    }
                }
            }
            
            self.sum = NetworkService.shared.getUser(userID: user!.id)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { output in
            self.organizations = NetworkService.shared.getOrganizations()
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var user: User? = User(id: "fgjh", username: "hkbkh", sum: 100)
    @State static var tasks: [TaskModel] = []
    @State static var email: String = ""
    
    static var previews: some View {
        ProfileView(user: $user, tasks: $tasks, email: email)
    }
}
