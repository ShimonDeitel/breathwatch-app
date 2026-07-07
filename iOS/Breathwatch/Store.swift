import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [SymptomEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Kept comfortably above seed count so a fresh install
    /// never hits the paywall on first launch.
    let freeLimit = 30

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("breathwatch_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < freeLimit
    }

    func add(_ entry: SymptomEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: SymptomEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: SymptomEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([SymptomEntry].self, from: data) {
            entries = decoded
        } else {
            entries = Store.seedData
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static var seedData: [SymptomEntry] {
        [
        SymptomEntry(petName: "Pet Name 1", symptom: "Symptom 1", severity: 1.0, date: Date().addingTimeInterval(-86400)),
        SymptomEntry(petName: "Pet Name 2", symptom: "Symptom 2", severity: 2.0, date: Date().addingTimeInterval(-172800)),
        SymptomEntry(petName: "Pet Name 3", symptom: "Symptom 3", severity: 3.0, date: Date().addingTimeInterval(-259200)),
        SymptomEntry(petName: "Pet Name 4", symptom: "Symptom 4", severity: 4.0, date: Date().addingTimeInterval(-345600)),
        SymptomEntry(petName: "Pet Name 5", symptom: "Symptom 5", severity: 5.0, date: Date().addingTimeInterval(-432000)),
        SymptomEntry(petName: "Pet Name 6", symptom: "Symptom 6", severity: 6.0, date: Date().addingTimeInterval(-518400))
        ]
    }
}
