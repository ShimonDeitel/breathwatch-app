import Foundation

struct SymptomEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var petName: String
    var symptom: String
    var severity: Double
    var date: Date

    init(id: UUID = UUID(), createdAt: Date = Date(), petName: String = "", symptom: String = "", severity: Double = 0, date: Date = Date()) {
        self.id = id
        self.createdAt = createdAt
        self.petName = petName
        self.symptom = symptom
        self.severity = severity
        self.date = date
    }
}
