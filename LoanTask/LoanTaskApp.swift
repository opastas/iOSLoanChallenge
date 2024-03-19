
import SwiftUI

@main
struct LoanTaskApp: App {
    private var loanTaskProjectDataManager = LoadTaskProjectDataManager()
    @State private var loanProject = LoanProject()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            LoanMenuView(loanProject: self.$loanProject)
                .onAppear(perform: {
                    loanTaskProjectDataManager.load { loanProject in
                        self.loanProject = loanProject
                    }
                })
                .onChange(of: scenePhase, perform: { phase in
                    if phase == .inactive {
                        loanTaskProjectDataManager.save(loanProject: self.loanProject)
                    }
                })
        }
    }
}
