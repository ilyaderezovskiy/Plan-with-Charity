//
//  CardView.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI

struct CardView: View {
    let name: String
    let description: String
    let urlPay: String
    var sum: Int

    var body: some View {
        ZStack {
            VStack() {
                Image("bg2")
                    .resizable()
                    .frame(width: 310, height: 250, alignment: .top)
                    .cornerRadius(20)
                    .opacity(0.35)
                    .overlay(ImageOverlay(name: name, description: description, urlPay: urlPay, sum: sum), alignment: .leading)
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
    let urlPay: String
    var sum: Int = 0
    @State var passedSum: Int = 0

    let numFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .font(.title)
                    .padding()

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
                        Spacer()
                        
                        VStack {
                            Text("Сумма перевода")
                            
                            HStack {
                                TextField("Сумма", value: $passedSum, formatter: numFormatter)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Text("₽")
                            }
                        }
                        .padding()

                        // Кнопка подтверждения денежного перевода
                        Button {
                            confirmationShown = true
                        } label: {
                            Text("Подтвердить перевод")
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 80))
                        .padding()
                        .confirmationDialog (
                            "Вы действительно совершили денежный перевод в размере указанной суммы?",
                            isPresented: $confirmationShown,
                            titleVisibility: .visible) {
                                Button("Да") {
                                    withAnimation {
                                        if passedSum > 0 && passedSum >= sum {
                                            UserDefaults.standard.set(0, forKey: "sum")
                                            var passed = UserDefaults.standard.integer(forKey: "passed") + passedSum
                                            UserDefaults.standard.set(passed, forKey: "passed")
                                        } else if passedSum > 0 {
                                            var newSum = UserDefaults.standard.integer(forKey: "sum") - passedSum
                                            UserDefaults.standard.set(newSum, forKey: "sum")
                                            var passed = UserDefaults.standard.integer(forKey: "passed") + passedSum
                                            UserDefaults.standard.set(passed, forKey: "passed")
                                        }
                                        shouldPresentSheet = false
                                    }
                                }
                                Button("Нет", role: .cancel) {
                                    shouldPresentSheet = false
                                }
                            }
//                            .disabled(self.sum == 0)
//                            .opacity(self.sum == 0 ? 0.6 : 1)
                    }

                    WebView(link: URL(string: urlPay)!)
                })
            }
            .padding(9)

            Spacer()

            HStack {
                Text(description)
                    .padding(5)
                    .font(.body)
                    .background(.white.opacity(0.6))
                    .cornerRadius(10)
                    .padding()

                Spacer()
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    @State static var username: String = ""
    static var sum: Int = 10

    static var previews: some View {
        CardView(name: "Дом с маяком", description: "иоилиоиоио", urlPay: "mm", sum: sum)
    }
}


