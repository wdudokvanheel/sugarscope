struct Theme: Identifiable, Encodable, Decodable, Equatable {
    var name: String
    var url: String
    var background: String
    var low: String
    var inRange: String
    var high: String
    var upper: String
    var indicatorLabel: String
    var indicatorIcon: String
    var gridLinesX: String
    var gridLinesY: String
    var labelAxisX: String
    var labelAxisY: String
    
    var id: String  {
        name
    }
}
