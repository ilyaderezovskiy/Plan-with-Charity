//
//  Organization.swift
//  Plan with Charity
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import SwiftUI

struct Organization: Identifiable {
    var id: String = UUID().uuidString
    let name: String
    let description: String
    let urlPay: String
}

func getOrganizations() -> [Organization] {
    let vera = Organization(name: "Вера", description: "Фонд помощи хосписам", urlPay: "https://fondvera.ru/donate/")
    let mayak = Organization(name: "Дом с маяком", description: "Хоспис для детей с тяжёлыми и ограничивающими жизнь заболеваниями", urlPay: "https://mayak.help/help/")
    let galchonok = Organization(name: "Галчонок", description: "Фонд помощи детям и молодёжи с органическими поражениями центральной нервной системы", urlPay: "https://www.bf-galchonok.ru/howtohelp/")
    let deti39 = Organization(name: "Верю в чудо", description: "Калининградский благотворительный центр помощи детям с тяжелыми заболеваниями и детям, находящимся в трудных жизненных обстоятельствах", urlPay: "https://www.deti39.com/monthly_donation/#.ZFwbKDPP1JV")
    let starikam = Organization(name: "Старость в радость", description: "Благотворительный фонд помощи пожилым людям и инвалидам", urlPay: "https://starikam.org/help/#donate")
    let ray = Organization(name: "РЭЙ", description: "Московский фонд помощи бездомным животным", urlPay: "https://rayfund.ru/get_involved/donate/")
    let homeless = Organization(name: "Ночлежка", description: "Благотворительный фонд помощи бездомным", urlPay: "https://homeless.ru/how_to_help/")
    return [vera, mayak, galchonok, deti39, starikam, ray, homeless]
}
