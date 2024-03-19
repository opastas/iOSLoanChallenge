
import SwiftUI

struct LoanMenuView: View {
    @Binding var loanProject: LoanProject
    var menuItems: [MenuItem] = MenuItem.menuItemData
    
    func formattedValue(_value: Double, _case: String) -> String {
        let numberFormatter = NumberFormatter()
        if (_value.isNaN) {
            return ""
        }
        numberFormatter.locale = Locale(identifier: "en_US")
        switch _case {
            case "int":
                numberFormatter.numberStyle = .currency
                numberFormatter.maximumFractionDigits = 0
            case "decimals": numberFormatter.numberStyle = .none
            case "ordinal": numberFormatter.numberStyle = .ordinal
            default: numberFormatter.numberStyle = .none
        }
        return numberFormatter.string(from: NSNumber(value: _value)) ?? "0"
    }
    
    
    var body: some View {
        // adjust values received from file - or received from api call.
        let fetchedItems = menuItems.map { (menuItem: MenuItem) -> MenuItem in
            let maxCreditAmount: Double = Double(loanProject.loanDetails?.maxCreditAmount ?? 0)
            let stringMaxCreditAmount: String = formattedValue(_value: maxCreditAmount, _case: "int")
            let repaymentDate: Double = Double(loanProject.loanDetails?.repaymentDay ?? 0)
            let stringRepaymentDate: String = formattedValue(_value: repaymentDate, _case: "ordinal")
            let numberOfDocuments: Double = Double(loanProject.loanDetails?.numberOfDocuments ?? 0)
            let stringNumberOfDocuments: String = formattedValue(_value: numberOfDocuments, _case: "docNumber")
            
            var auxItem = menuItem
            switch auxItem.title {
                case MenuItem.increaseCredit: auxItem.specificDetail = stringMaxCreditAmount
            case MenuItem.changeRepayment: auxItem.specificDetail = stringRepaymentDate
            case MenuItem.updatePayment: auxItem.specificDetail = loanProject.loanDetails?.lastFourPaymentCard ?? ""
            case MenuItem.updatePersonalInfo: auxItem.detailMsg = loanProject.email ?? ""
            case MenuItem.viewSavedDocs: auxItem.specificDetail = stringNumberOfDocuments
                default: auxItem.detailMsg = ""
            }
            
            return auxItem
        }
        NavigationView {
            List {
                ForEach(fetchedItems) { menuItem in
                    ZStack {
                        MenuItemCard(menuItem: menuItem)
                        // only add navigation to our first item in list
                        if (menuItem.title == MenuItem.increaseCredit) {
                            NavigationLink(destination: LoanDetailView(loanProject: $loanProject)) {
                            
                            }.opacity(0)
                        }
                    }
                }
            }.navigationTitle("More options")
            .listStyle(.insetGrouped)
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .leading)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    struct StatefulPreviewWrapper: View {
        @State private var testProjects = LoanProject.testData
        
        var body: some View {
            LoanMenuView(loanProject: $testProjects, menuItems: MenuItem.menuItemData)
        }
    }
    
    static var previews: some View {
        StatefulPreviewWrapper()
    }
}
