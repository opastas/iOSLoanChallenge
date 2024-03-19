import Foundation

struct LoanProject: Codable {
    var email: String?
    var paymentDetails: PaymentDetails?
    var loanDetails: LoanDetails?
    
}

struct LoanDetails: Codable {
    var loanID : String?
    var remainingBalance : Int?
    var amountBorrowed : Int?
    var interestPaidToDate : Double?
    var interestRate : Double?
    var maxCreditAmount : Int?
    var repaymentDay : Int?
    var lastFourPaymentCard : String?
    var numberOfDocuments : Int?
    
}

struct PaymentDetails: Codable {
    var dueInDays : Int?
    var amountDue : Double?
    var nextPaymentDate : String?
    var paymentProgress : PaymentProgress?
}

struct PaymentProgress : Codable {
    var currentPaymentNumber : Int?
    var totalPayments : Int?
    
}

extension LoanProject {
    static var testData: LoanProject
    {
        return (
            LoanProject(email: "example@example.com",
                        paymentDetails:
                            PaymentDetails(
                                dueInDays: 2,
                                amountDue: 325.93,
                                nextPaymentDate: "2024-02-24",
                                paymentProgress:
                                    PaymentProgress(
                                        currentPaymentNumber: 8,
                                        totalPayments: 10
                                    )
                            ),
                        loanDetails:
                            LoanDetails(
                                loanID: "JMI-923429",
                                remainingBalance: 652,
                                amountBorrowed: 3250,
                                interestPaidToDate: 319.77,
                                interestRate: 9.9,
                                maxCreditAmount: 10000,
                                repaymentDay: 12,
                                lastFourPaymentCard: "7284",
                                numberOfDocuments: 4
                            )
                       )
        )
    }
}
