
import Foundation

struct LoadTaskProjectDataManager {
    func load(completion: @escaping (LoanProject) -> Void) {
        DispatchQueue.global(qos: .background).async {
            
            // Copy the details.json file to the user's documents folder if it's not already there
            // (you and I should never save files back to the application bundle directory, so make an initial copy)
            if FileManager.default.fileExists(atPath: Self.fileURL.path) == false {
                let bundledProjectsURL = Bundle.main.url(forResource: "details", withExtension: "json")!
                try! FileManager.default.copyItem(at: bundledProjectsURL, to: Self.fileURL)
            }
            
            // Attempt to load the contents of the details.json file that's in the user's documents folder
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                return
            }
            
            // Prepare a JSONDecoder, ensuring that it can successfully decode dates into the Swift Date type
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            // Attempt to decode the JSON document into an array of LoanProject instances
            guard let loanProject = try? decoder.decode(LoanProject.self, from: data) else {
                fatalError("Can't decode saved renovation project data.")
            }
            
            // Pass the array of LoanProject instances back to the caller through the completion handler that is passed in
            DispatchQueue.main.async {
                completion(loanProject)
            }
        }
    }
    
    // This option is useful if edit an item is required and then should be saved.
    func save(loanProject: LoanProject) {
        DispatchQueue.global(qos: .background).async {
            // Prepare a JSONEncoder, ensuring that it can successfully re-encode dates from the Swift Date type into text within the resulting JSON representation
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            
            // Attempt to encode the array of LoanProject instances into a JSON document
            guard let loanProjectsData = try? encoder.encode(loanProject) else { fatalError("Error encoding data") }
            do {
                // Write the encoded JSON document to the user's document's folder
                let outfile = Self.fileURL
                try loanProjectsData.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
    
    // MARK: Helper functions
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("details.json")
    }
}
