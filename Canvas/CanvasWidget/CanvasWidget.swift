import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DateEntry {
        DateEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DateEntry) -> ()) {
        let entry = DateEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let entry = DateEntry(date: currentDate)
        let timeline = Timeline(entries: [entry], policy: .after(endOfDay))
        completion(timeline)
    }
}

struct DateEntry: TimelineEntry {
    let date: Date
}

struct ShapeView: View {
    var image: UIImage?
    var color: Color
    
    init(level: Int, color: Color) {
        self.image = ThemeManager.shared.getThemeInstance().getImageByGaugeLevel(gaugeLevel: level)
        self.color = color
    }
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .renderingMode(.template)
                .frame(width: nil, height: nil, alignment: .center)
                .foregroundColor(color)
        }
    }
}

struct CanvasWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack{
            Color(canvasColor).edgesIgnoringSafeArea(.all)
                .cornerRadius(15)
            GeometryReader { geometry in
                let width: CGFloat = sizeRatio * geometry.size.width
                
                ForEach(0 ..< getIndex(recordNum: records.count)) { index in
                    let record = records[index]
                    
                    ShapeView(level: Int(record.gaugeLevel),
                              color: Color(ThemeManager.shared.getThemeInstance().getColorByGaugeLevel(gaugeLevel: Int(record.gaugeLevel))))
                        .position(x: CGFloat(record.xRatio) * geometry.size.width,
                                  y: CGFloat(record.yRatio) * geometry.size.height)
                        .frame(width: width,
                               height: width,
                               alignment: .center)
                }
                
                if UserDefaults.shared.bool(forKey: "guideAvail") == true {
                    ForEach(getIndex(recordNum: records.count) ..< 10) { index in
                        let record = DefaultRecord.data[index]
                        let pos = defaultPosition[index]
                        ShapeView(level: Int(record.gaugeLevel), color: .gray)
                            .position(x: CGFloat(pos.xRatio) * geometry.size.width,
                                      y: CGFloat(pos.yRatio) * geometry.size.height)
                            .frame(width: width,
                                   height: width,
                                   alignment: .center)
                    }
                }
                
            }
        }
        .padding(10)
        .background(Color(bgColor))
    }
    
    var sizeRatio: CGFloat {
        var size = RecordViewRatio()
        
        if  UserDefaults.shared.bool(forKey: "guideAvail") == true {
            size.ratio = CGFloat(10)
        } else {
            size.ratio = CGFloat(records.count)
        }
        return size.ratio
    }
    
    var records: [Record] {
        let context = CoreDataStack.shared.managedObjectContext
        let request = Record.fetchRequest()
        var records: [Record] = [Record]()
        let todayString = getDateString(date: Date())
        var todayRecords = [Record]()
        
        do {
            records = try context.fetch(request)
        } catch { print("context Error") }
        records.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow > $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
        if UserDefaults.shared.bool(forKey: "canvasMode") == false {
            return records
        }
        for record in records {
            if getDateString(date: record.createdDate ?? Date()) == todayString {
                todayRecords.append(record)
            }
        }
        return todayRecords
    }
    
    var defaultPosition: [DefaultPosition] {
        let context = CoreDataStack.shared.managedObjectContext
        let request = DefaultPosition.fetchRequest()
        var positions: [DefaultPosition] = [DefaultPosition]()
        
        do {
            positions = try context.fetch(request)
        } catch { print("context Error") }
        return positions
    }
    
    private func getDateString(date: Date) -> String {
        let df = DateFormatter()
        
        df.dateFormat = "yyyy. M. d"
        df.locale = Locale(identifier:"ko_KR")
        return df.string(from: date)
    }
    
    private func getIndex(recordNum: Int) -> Int {
        if recordNum < 10 {
            return recordNum
        } else {
            return 10
        }
    }
}

@main
struct CanvasWidget: Widget {
    let kind: String = "CanvasWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CanvasWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(widgetDisplayName)
        .description(widgetDescription)
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}

struct CanvasWidget_Previews: PreviewProvider {
    static var previews: some View {
        CanvasWidgetEntryView(entry: DateEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        CanvasWidgetEntryView(entry: DateEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

extension Date {
    
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
}
