//
//  PlannerWidget.swift
//  PlannerWidget
//
//  Created by Ilya Derezovskiy on 18.05.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(name: "Вера", description: "Благотворительный фонд был основан в 2006 году Нютой Федермессер. «Вера» стремится к тому, чтобы каждый неизлечимо больной человек в России мог получить качественную паллиативную помощь", date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(name: "Вера", description: "Благотворительный фонд был основан в 2006 году Нютой Федермессер. «Вера» стремится к тому, чтобы каждый неизлечимо больной человек в России мог получить качественную паллиативную помощь", date: Date(), configuration: ConfigurationIntent())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let widgetInfo = getWidgetInfo()
        var entries: [SimpleEntry] = []
        
        let threeSeconds: TimeInterval = 60
        var currentDate = Date()
        let endDate = Calendar.current.date(byAdding: .minute, value: 20, to: currentDate)!

        while currentDate < endDate {
            for item in widgetInfo {
                let entry = SimpleEntry(name: item.title, description: item.description, date: currentDate, configuration: configuration)
                entries.append(entry)
                currentDate += threeSeconds
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CardView: View {
    let name: String
    let description: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: -15) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack() {
                        Text("Планируй, помогая!")
                            .font(.caption2.weight(.bold))
                            .padding(11)
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                    
                        Spacer()
                    }
                    .background(Color("Crayola Bleuet"))
                    
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(height: 1)
                }
                
                Spacer(minLength: 10)
                
                Text(name)
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)
                
                Spacer()
                
                Text(description)
                    .font(.caption2)
                    .padding()

//                HStack(spacing: -45) {
//                    Text(description)
//                        .font(.caption2)
//                        .padding()
//                }

            }
            
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let name: String
    let description: String
    let date: Date
    let configuration: ConfigurationIntent
}

struct PlannerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        CardView(name: entry.name, description: entry.description)
    }
}

@main
struct PlannerWidget: Widget {
    let kind: String = "PlannerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PlannerWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Планируй, помогая!")
        .description("Планировщик задач с функцией перевода денежных средств в благотворительные организации")
    }
}

struct PlannerWidget_Previews: PreviewProvider {
    static var previews: some View {
        PlannerWidgetEntryView(entry: SimpleEntry(name: "Вера", description: "Благотворительный фонд был основан в 2006 году Нютой Федермессер. «Вера» стремится к тому, чтобы каждый неизлечимо больной человек в России мог получить качественную паллиативную помощь ", date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct WidgetInfo: Identifiable {
    var id: String = UUID().uuidString
    let title: String
    let description: String
}

func getWidgetInfo() -> [WidgetInfo] {
    let info1 = WidgetInfo(title: "Что такое паллиативная помощь?", description: "Паллиативная помощь направлена на улучшение качества жизни человека с тяжелым и опасным для здоровья заболеванием. Чтобы каждый неизлечимо больной человек мог получить качественную помощь вне зависимости от места жительства, возраста и материального положения")
    
    let info2 = WidgetInfo(title: "Дом с Маяком", description: "Детский хоспис «Дом с Маяком» — частное медицинское благотворительнице учреждение. Учредители — Нюта Федермессер и Лида Мониава")
    
    let info17 = WidgetInfo(title: "Дом с Маяком", description: "Цель «Дома с маяком» — создать для ребенка с неизлечимой болезнью и для его семьи условия для счастливой и полной радостными событиями жизни, избавить от боли и одиночества")
    
    let info3 = WidgetInfo(title: "Вера", description: "Благотворительный фонд был основан в 2006 году Нютой Федермессер. «Вера» стремится к тому, чтобы каждый неизлечимо больной человек в России мог получить качественную паллиативную помощь вне зависимости от места жительства, возраста, материального положения")
    
    let info4 = WidgetInfo(title: "Верю в чудо", description: "Калининградский фонд помогает разным детям: с тяжелыми заболеваниями, с особенностями здоровья, воспитанникам детских домов, детям из многодетных и малообеспеченных семей, а также поддерживает деятельность детских медицинских и социальных учреждений и их работников")
    
    let info5 = WidgetInfo(title: "Ночлежка", description: "Благотворительный фонд помощи бездомным «Ночлежка» был инициативой группы ленинградских волонтеров, которые раздавали еду людям, оказавшимся на улице, а в 1990 году создали общественную организацию")
    
    let info6 = WidgetInfo(title: "РЭЙ", description: "Московский фонд помощи бездомным животным поддерживает более 40 приютов в Москве, Подмосковье и близлежащих областях, где живет около 16 тыс. бездомных собак и кошек")
    
    let info18 = WidgetInfo(title: "РЭЙ", description: "Фонд закупает для приютов корм, медикаменты и стройматериалы, оказывает помощь в лечении и стерилизации животных, помогает найти им постоянный или временный дом")
    
    let info7 = WidgetInfo(title: "Старость в радость", description: "Благотворительный фонд начался с одного человека — студентки-филолога Лизы Олескиной. Первокурсница, съездив на студенческую практику в Псковскую область весной 2006 года и посетив местный дом престарелых, поняла, что одиноких пожилых людей много, а организаций, которые бы помогли им, почти нет")
    
    let info8 = WidgetInfo(title: "Дом с Маяком", description: "Фонд поддерживает детские хосписы Москвы и Московской области и реализует собственные программы, например, развивает выездную службу паллиативной помощи детям и молодым взрослым до 25 лет. Ежегодно такую помощь получают приблизительно 800 детей")
    
    let info9 = WidgetInfo(title: "Верю в чудо", description: "Фонд реализует восемь благотворительных программ и за более чем десять лет работы оказал помощь свыше 45 тыс. детей по всей Калининградской области. Также фонд поддерживает паллиативных детей и обучает специалистов и родителей ухаживать за такими детьми")
    
    let info10 = WidgetInfo(title: "Вера", description: "Фонд поддерживает работу московских, подмосковных и региональных хосписов для взрослых и детей, оказывает адресную помощь людям с тяжелыми заболеваниями, консультирует по Горячей линии, ведет просветительскую работу среди медиков и обычных людей")
    
    let info11 = WidgetInfo(title: "Ночлежка", description: "У «Ночлежки» множество направлений работы: одно из них — реабилитационный приют для бездомных и действующая при нем консультационная служба, где люди могут получить юридическую помощь по вопросам регистрации, медицинского полиса, документов")
    
    let info12 = WidgetInfo(title: "РЭЙ", description: "Фонд организует фестивали и благотворительные ярмарки, посвящённые бережному и ответственному обращению с животными, и проводит бесплатный образовательный курс «Лапа дружбы» для школьников и студентов")
    
    let info13 = WidgetInfo(title: "Старость в радость", description: "Фонд курирует 150 домов-интернатов в 25 российских регионах и реализует там программы медицинской, материальной и реабилитационной помощи")
    
    let info19 = WidgetInfo(title: "Старость в радость", description: "Команда фонда постоянно выезжает в дома престарелых с праздниками и концертами, передает подарки и письма, улучшает бытовые условия для бабушек и дедушек, живущих в своих квартирах")
    
    let info14 = WidgetInfo(title: "Дом с маяком", description: "Фонд исполняет желания своих подопечных, дает передышку родителям, поддерживает семью после утраты ребенка. Организация занимается и перинатальной паллиативной помощью: берет под опеку семьи, где родители хотят сохранить ребенка со сложным диагнозом и плохим прогнозом")
    
    let info15 = WidgetInfo(title: "Вера", description: "Фонд обучает будущих профессиональных помощников для помощи людям в конце жизни, а для сотрудников хосписов, сиделок, волонтеров и родственников пациентов организует «Мастерскую заботы» — школу правильного ухода за тяжелобольными людьми")
    
    let info16 = WidgetInfo(title: "Ночлежка", description: "С начала своей работы «Ночлежка» помогла 100 тыс. бездомных, а в 2018 году открыла отделение в Москве. По словам директора фонда около 60% подопечных «Ночлежки» больше не оказываются на улице")
    
    return [info1, info2, info17, info3,
            info4, info5, info6, info18,
            info7, info8, info9, info10,
            info11, info12, info13, info19,
            info14, info15, info16]
}
