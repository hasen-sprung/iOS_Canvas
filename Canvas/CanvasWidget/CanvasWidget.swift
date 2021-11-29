import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct ShapeView: View {
    var image: UIImage?
    var color: Color
    
    init(level: Int) {
        self.image = ThemeManager.shared.getThemeInstance().getImageByGaugeLevel(gaugeLevel: level)
        self.color = Color(ThemeManager.shared.getThemeInstance().getColorByGaugeLevel(gaugeLevel: level))
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
                    
                    ShapeView(level: Int(record.gaugeLevel))
                        .position(x: CGFloat(record.xRatio) * geometry.size.width,
                                  y: CGFloat(record.yRatio) * geometry.size.height)
                        .frame(width: width,
                               height: width,
                               alignment: .center)
                }
            }
        }
        .padding(10)
        .background(Color(bgColor))
    }
    
    var sizeRatio: CGFloat {
        var size = RecordViewRatio()
        
        size.ratio = CGFloat(records.count)
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
        for record in records {
            if getDateString(date: record.createdDate ?? Date()) == todayString {
                todayRecords.append(record)
            }
        }
        return todayRecords
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
        CanvasWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        CanvasWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
