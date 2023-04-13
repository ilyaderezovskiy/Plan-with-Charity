//
//  CardView.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 08.04.2023.
//

import SwiftUI

struct CardView: View {
    let name: String
    let description: String
    let urlInfo: String
    let urlPay: String
    @Binding var sum: Int
    @Binding var user: User?
    
    var body: some View {
        ZStack {
            VStack() {
                Image("bg2")
                    .resizable()
                    .frame(width: 310, height: 250, alignment: .top)
                    .cornerRadius(20)
                    .opacity(0.35)
                    .overlay(ImageOverlay(name: name, description: description, urlInfo: urlInfo, urlPay: urlPay, sum: $sum, user: $user), alignment: .leading)
            }
            .frame(width: 330, height: 250, alignment: .top)
        }
    }
}

// Информация о благотворительной организации
struct ImageOverlay: View {
    @State private var confirmationShown = false
    @State var shouldPresentSheet = false
    let name: String
    let description: String
    let urlInfo: String
    let urlPay: String
    @Binding var sum: Int
    @Binding var user: User?
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .font(.title)
                    .padding()
                
                //                Button {
                //                    shouldPresentSheet.toggle()
                //                } label: {
                //                    Image(systemName: "info.circle")
                //                        .foregroundColor(.black)
                //                        .font(.system(size: 35))
                //                }
                //                .cornerRadius(10)
                //                .sheet(isPresented: $shouldPresentSheet, content: {
                //                    Button("Вернуться") {
                //                        shouldPresentSheet = false
                //                    }.padding()
                //
                //                    WebView(link: URL(string: urlInfo)!)
                //                })
                
                Spacer()
                
                Button {
                    shouldPresentSheet.toggle()
                } label: {
                    Image(systemName: "rublesign.square")
                        .foregroundColor(.black)
                        .font(.system(size: 45))
                }
                .cornerRadius(10)
                .sheet(isPresented: $shouldPresentSheet, content: {
                    HStack {
                        Button("Вернуться") {
                            shouldPresentSheet = false
                        }.padding()
                        
                        Spacer()
                        
                        // Кнопка подтверждения денежного перевода
                        Button {
                            confirmationShown = true
                        } label: {
                            Text("Перевод совершён")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 80))
                        .padding()
                        .confirmationDialog (
                            "Вы действительно совершили денежный перевод в размере (не менее) вашей накопленной суммы?",
                            isPresented: $confirmationShown,
                            titleVisibility: .visible) {
                                Button("Да") {
                                    withAnimation {
                                        Task {
                                            do {
                                                try await NetworkService.shared.editUser(user: User(id: user!.id, username: user!.username, sum: 0))
                                            } catch {
                                                print("Error")
                                            }
                                        }
                                        self.sum = 0
                                        self.user!.sum = 0
                                        shouldPresentSheet = false
                                    }
                                }
                                Button("Нет", role: .cancel) {
                                    shouldPresentSheet = false
                                }
                            }
                            .disabled(self.user!.sum == 0)
                            .opacity(self.user!.sum == 0 ? 0.6 : 1)
                    }
                    
                    WebView(link: URL(string: urlPay)!)
                })
            }
            .padding(9)
            
            Spacer()
            
            HStack {
                Text(description)
                    .font(.title3)
                    .padding()
                
                Spacer()
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    @State static var user: User? = User(id: "fgjh", username: "hkbkh", sum: 100)
    @State static var sum: Int = 10
    
    static var previews: some View {
        CardView(name: "Дом с маяком", description: "иоилиоиоио", urlInfo: "nn", urlPay: "mm", sum: $sum, user: $user)
    }
}
