
import SwiftUI

struct LoanProjectDetailCard: View {
    var loanProject: LoanProject

    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextDetails(loanProject: self.loanProject)
            .navigationBarBackButtonHidden(true)
            
        }
    }

    
}

struct TextDetails: View {
    let loanProject: LoanProject
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func formattedValue(_value: Double, _case: String) -> String {
        let numberFormatter = NumberFormatter()
        if (_value.isNaN) {
            return ""
        }
        numberFormatter.locale = Locale(identifier: "en_US")
        switch _case {
            case "int": numberFormatter.numberStyle = .currency
            case "decimals": numberFormatter.numberStyle = .none
            default: numberFormatter.numberStyle = .none
        }
        return numberFormatter.string(from: NSNumber(value: _value)) ?? "0"
    }
    
    func formattedDateValue(_value: String, _case: String) -> String {
        let dateFormatter = DateFormatter()
        let stringFormatter = DateFormatter()
        stringFormatter.locale = Locale(identifier: "en_GB")
        switch _case {
            case "yyyy-MM-dd": stringFormatter.setLocalizedDateFormatFromTemplate("MMMd")
            default: stringFormatter.setLocalizedDateFormatFromTemplate("MMMd")
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dueDate: Date = dateFormatter.date(from: _value)!
        
        return stringFormatter.string(from: dueDate)
    }
    
    var btnBack : some View { Button(action: {
            presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Text(Image(systemName: "arrow.backward.circle.fill"))
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding(2)
                        .background(Color.gray)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .frame(width: 50, height: 50, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                    
                    
                    
                    
//                Image(systemName: ) // set image here
//                    .aspectRatio(contentMode: .fit)
//                    .foregroundColor(.black)
//                    .background(Color.gray)
//                    Text("Go back").padding()
//                        .frame(width: 100, height: 100, alignment: .center)
                }
            }
        }
    
    var body: some View {
        let dueDays: Double = Double(loanProject.paymentDetails?.dueInDays ?? 0)
        let stringDueDays: String = formattedValue(_value: dueDays, _case: "day")
        let currentPaymentProgress: Double =  Double(loanProject.paymentDetails?.paymentProgress?.currentPaymentNumber ?? 0)
        let totalPayments: Double =  Double(loanProject.paymentDetails?.paymentProgress?.totalPayments ?? 0)

        ZStack() {
            Rectangle().fill(Color.white).navigationBarItems(leading: btnBack)
            Image("bitcoin")
                .resizable()
                .scaledToFit()
                .position(x: UIScreen.screenWidth, y: UIScreen.screenHeight/7)
            
            VStack(alignment: .leading) {
                
                Text("Due in: \(stringDueDays) \((dueDays > 1) ? "days" : "day")")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                HStack {
                Text(formattedValue(_value: (loanProject.paymentDetails?.amountDue)!, _case: "int"))
                    .font(.title)
                    .foregroundColor(.black)
                    .bold()
                    Spacer()
                    CardNumberView(lastFourPaymentCard: loanProject.loanDetails?.lastFourPaymentCard ?? "")
                }
                
//                    Text("." + formattedValue(_value: (loanProject.paymentDetails?.amountDue)!, _case: "decimals"))
//                        .font(.title)
//                        .foregroundColor(.black)
//                        .bold()
                
                Divider().opacity(0)
                if #available(iOS 15.0, *) {
                    HStack {
                        TextBlockView(nextPaymentDate: formattedDateValue(_value: (loanProject.paymentDetails?.nextPaymentDate)!, _case: "yyyy-MM-dd"), currentPaymentProgress: formattedValue(_value: currentPaymentProgress, _case: "payment"),
                        totalPayments: formattedValue(_value: totalPayments, _case: "payment"))
                    }.dynamicTypeSize(.small)
                    .font(.system(size: 12))
                } else {
                    // Fallback on earlier versions
                    TextBlockView(nextPaymentDate: formattedDateValue(_value: (loanProject.paymentDetails?.nextPaymentDate)!, _case: "yyyy-MM-dd"), currentPaymentProgress: formattedValue(_value: currentPaymentProgress, _case: "payment"),
                        totalPayments: formattedValue(_value: totalPayments, _case: "payment"))
                        .font(.system(size: 12))
                }
                Button(action: {
                        print("Make a payment")
                    }) {
                        Text("Make a payment")
                            .bold()
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth)
                            .font(.system(size: 14))
                            .padding()
                            .foregroundColor(.white)
                            .overlay(
                                Capsule()
                                    .stroke(Color.white, lineWidth: 2)
                        )
                    }
                    .background(Color.purple)
                    .cornerRadius(25)
                
            }
            .padding()
        }
        .foregroundColor(.white)
        .navigationBarBackButtonHidden(true)
    }
    
}

struct TextBlockView : View {
    var nextPaymentDate: String
    var currentPaymentProgress : String
    var totalPayments : String
    var body : some View {
        Text("\(Text("Next Payment: ").foregroundColor(.gray)) \(Text(nextPaymentDate).bold().foregroundColor(.black))")
        
        Spacer()
        Text("\(Text("\(currentPaymentProgress)").foregroundColor(.black)) \(Text("of \(totalPayments) payments").foregroundColor(.gray))")
            .padding(20)
            .navigationBarBackButtonHidden(true)
    }
}

struct CardNumberView : View {
    var lastFourPaymentCard: String
    var body: some View {
        ZStack {
            Image("card")
                .resizable()
                .frame(width: UIScreen.screenWidth / 5, height: UIScreen.screenHeight / 10, alignment: .leading)
                .padding()
                .overlay(
                    ZStack(alignment: .leading) {
                        Text(lastFourPaymentCard)
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                            .bold()
                    }
                        .padding([.top, .leading])
                )
        }.navigationBarBackButtonHidden(true)
    }
}


struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        if #available(iOS 15.0, *) {
            Button(action: action) {
                Image(systemName: "arrow.backward.circle.fill")
            }
            .symbolVariant(.circle.fill)
            .font(.title)
        } else {
            // Fallback on earlier versions
        }
    }
}

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
//extension Text {
//    func coloredText(_ color: Color) -> Text {
//        self.foregroundColor(color)
//    }
//}


struct LoanProjectDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        LoanProjectDetailCard(loanProject: LoanProject.testData)
    }
}
