//
//  AuthView.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 06.04.2023.
//

import SwiftUI

struct AuthView: View {
    
    @State var login: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var showCalendarView = false
    @State var user: User?
    @State var result: String = ""
    @State var isSecure: Bool = true
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 0)
                .foregroundColor(.blue)
                .opacity(0.3)
            Spacer()
        }.ignoresSafeArea()
            .background(Image("bg")
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
                .opacity(0.7)
            )
            .overlay {
                VStack(spacing: 20) {
                    TextField("Введите логин:", text: $login)
                        .padding()
                        .background(.white)
                        .cornerRadius(15)
                        .padding(.top, 130)
                    
                    TextField("Введите email:", text: $email)
                        .padding()
                        .background(.white)
                        .cornerRadius(15)
                    
                    HStack {
                        Group {
                            if isSecure {
                                SecureField("Введите пароль:", text: $password)
                            } else {
                                TextField("Введите пароль:", text: $password)
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: isSecure)
                        
                        Button(action: {
                            isSecure.toggle()
                        }, label: {
                            Image(systemName: !isSecure ? "eye.slash" : "eye" )
                                .font(.system(size: 25))
                                .foregroundColor(Color("Blue"))
                        })
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(15)
                    
                    Text("\(self.result)")
                        .foregroundColor(.red)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    // Кнопка авторизации пользователя
                    Button {
                        Task {
                            do {
                                if checkInfo(isRegistration: false) {
                                    self.user = try await NetworkService.shared.auth(login: login, email: email, password: password)
                                    NetworkService.shared.getTasks(userID: user!.id)
                                    self.showCalendarView.toggle()
                                }
                            } catch {
                                self.result = "Ошибка авторизации - Пользователь с таким логином и паролем не найден"
                            }
                        }
                    } label: {
                        Text("Войти")
                    }.frame(maxWidth: .infinity)
                        .padding()
                        .background(.brown)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    
                    // Кнопка регистрации пользователя
                    Button {
                        Task {
                            do {
                                if checkInfo(isRegistration: true) {
                                    self.user = try await NetworkService.shared.signup(id: UUID().uuidString, login: login, email: email, password: password, sum: 0)
                                    self.showCalendarView.toggle()
                                }
                            } catch {
                                self.result = "Ошибка регистрации - Пользователь с таким логином уже существует"
                            }
                        }
                    } label: {
                        Text("Зарегистрироваться")
                    }.frame(maxWidth: .infinity)
                        .padding()
                        .background(.brown)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    
                }.padding(.horizontal, 40)
            }
            .fullScreenCover(isPresented: $showCalendarView) {
                CalendarView(user: $user, email: email)
            }
    }
    
    // Проверка введённой пользователем информации
    func checkInfo(isRegistration: Bool?) -> Bool {
        self.result = ""
        if self.login == "" || self.password == "" {
            self.result.append("! Поля логина и пароля обязательны для заполнения\n")
            return false
        }
        
        if self.login.contains(" ") || self.login.range(of: ".*[^А-Яа-яA-Za-z0-9].*", options: .regularExpression) != nil {
            self.result.append("! Логин не может содержать специальных символов и пробелов\n")
            return false
        }
        
        if self.password.contains(" ") || self.password.range(of: ".*[^А-Яа-яA-Za-z0-9].*", options: .regularExpression) != nil {
            self.result.append("! Пароль не может содержать специальных символов и пробелов\n")
            return false
        }
        
        if self.password.count < 5 {
            self.result.append("! Пароль должен содержать больше 4 символов\n")
            return false
        }
        
        if isRegistration == true {
            if self.email.count == 0 || self.email.contains(" ") || !self.email.contains("@") || !self.email.contains(".") {
                self.result.append("! Некорректный формат адреса эл. почты\n")
                return false
            }
        }
        
        return true
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}


