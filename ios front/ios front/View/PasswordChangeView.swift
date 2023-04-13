//
//  PasswordChangeView.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 08.04.2023.
//

import SwiftUI

struct PasswordChangeView: View {
    @State var oldPassword: String = ""
    let email: String
    @State var newPassword: String = ""
    @State var checkUser: User?
    @State var result: String = ""
    @Binding var user: User?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack(spacing: 20) {
            Button("Вернуться") {
                dismiss()
            }
            
            HStack {
                Text("Старый пароль:")
                    .padding(.top, 130)
                
                Spacer()
            }
            
            TextField("Введите старый пароль", text: $oldPassword)
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(15)
            
            HStack {
                Text("Новый пароль:")
                
                Spacer()
            }
            
            TextField("Введите новый пароль", text: $newPassword)
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(15)
            
            Button("Сменить пароль") {
                if checkInfo() == true {
                    self.result = ""
                    Task {
                        do {
                            // Проверка соответствия старого пароля аккаунту пользователя
                            self.checkUser = try await NetworkService.shared.auth(login: self.user!.username, email: "email", password: self.oldPassword)
                            
                            if self.checkUser != nil {
                                Task {
                                    do {
                                        NetworkService.shared.deleteUser(userID: self.user!.id)
                                        
                                        try await NetworkService.shared.signup(id: self.user!.id, login: self.user!.username, email: self.email, password: self.newPassword, sum: self.user!.sum)
                                    } catch {
                                        self.result = "Произошла ошибка. Введён неверный старый пароль"
                                    }
                                }
                            }
                            self.result = "Пароль успешно изменён"
                        } catch {
                            self.result = "Произошла ошибка. Введён неверный старый пароль"
                        }
                    }
                }
            }
            .padding()
            
            Text("\(self.result)")
            Spacer()
        }
        .padding()
    }
    
    // Проверка корректности введённых паролей
    func checkInfo() -> Bool {
        self.result = ""
        
        if self.newPassword.contains(" ") || self.newPassword.range(of: ".*[^А-Яа-яA-Za-z0-9].*", options: .regularExpression) != nil {
            self.result.append("! Пароль не может содержать специальных символов и пробелов\n")
            return false
        }
        
        if self.newPassword.count < 5 {
            self.result.append("! Пароль должен содержать больше 4 символов\n")
            return false
        }
        
        return true
    }
}

struct PasswordChangeView_Previews: PreviewProvider {
    @State static var user: User? = User(id: "fgjh", username: "hkbkh", sum: 100)
    @State static var email: String = ""
    
    static var previews: some View {
        PasswordChangeView(email: email, user: $user)
    }
}
