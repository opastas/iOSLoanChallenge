import Foundation

struct MenuItem: Identifiable, Codable {
    static let increaseCredit = "Increase Paydown Credit"
    static let changeRepayment = "Change repayment date"
    static let updatePayment = "Update payment details"
    static let updatePersonalInfo = "Update personal information"
    static let viewSavedDocs = "View saved documents"
    
    let id: UUID
    var title: String
    var systemImage: String
    var detailMsg: String
    var specificDetail: String
    
    init(id: UUID = UUID(), title: String, systemImage: String, detailMsg: String, specificDetail: String) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.detailMsg = detailMsg
        self.specificDetail = specificDetail
    }
}

extension MenuItem {
    
    static let menuItemData: [MenuItem] =
    [
        MenuItem(title: increaseCredit,
                 systemImage: "arrow.right.circle.fill",
                 detailMsg: "Up to ",
                 specificDetail: "$10.000"),
        MenuItem(title: changeRepayment,
                 systemImage: "calendar",
                 detailMsg: "Currently on the ",
                 specificDetail: "12th"),
        MenuItem(title: updatePayment,
                 systemImage: "note",
                 detailMsg: "Account ending ",
                 specificDetail: "7284"),
        MenuItem(title: updatePersonalInfo,
                 systemImage: "person.fill",
                 detailMsg: "example@example.com",
                 specificDetail: ""),
        MenuItem(title: viewSavedDocs,
                 systemImage: "doc",
                 detailMsg: "documents",
                 specificDetail: "4")
    ]
}
