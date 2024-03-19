
import SwiftUI

struct LoanDetailView: View {
    @Binding var loanProject: LoanProject
    @State private var showEditView = false
    
    var body: some View {
        NavigationView {
        ZStack {
            
            if #available(iOS 15.0, *) {
                Color(uiColor: UIColor.systemGray3).ignoresSafeArea()
            } else {
                // Fallback on earlier versions
                Color.gray.ignoresSafeArea()
            }
            VStack(alignment: .leading) {
                Spacer()
                
                    ProjectProgressView(amountBorrowed: Double(loanProject.loanDetails?.amountBorrowed ?? 0), amountLeft: Double(loanProject.loanDetails?.remainingBalance ?? 0))
                if #available(iOS 15.0, *) {
                    GridBlockView(colorBackground: Color(uiColor: UIColor.systemGray3), loanProject: loanProject).frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 2)
                } else {
                    // Fallback on earlier versions
                    GridBlockView(colorBackground: Color.gray, loanProject: loanProject).frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 2)
                }
            }.navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        VStack(alignment: .leading) {
                            Text("Loan").font(.largeTitle).bold()
                            Text("Details").font(.largeTitle).bold()
                        }.frame(width: 200, height: 200, alignment: .leading)
                    }
                }
            }
        }
    }
}

struct MultiTextView : View {
    
    var body : some View {
        VStack {
            Text("Test")
            Text("Test")
        }
    }
    
}

private let adaptiveColumns = [
    GridItem(.adaptive(minimum: 120)),
    GridItem(.adaptive(minimum: 120))
]

struct GridBlockView : View {
    var colorBackground: Color
    var loanProject: LoanProject
    
    var body : some View {
        
            LazyVGrid (columns: adaptiveColumns, spacing: 10) {
                ForEach(1...4, id: \.self) { item in
                    ZStack {
                        Rectangle().frame(width: UIScreen.screenWidth/2.3, height: UIScreen.screenHeight/4.9)
                            .cornerRadius(10).padding(UIScreen.screenWidth / 30)
                        
                        
                        TextGridView(item: item, loanProject: loanProject)
                        
                                        
                    }.foregroundColor(.gray)
                        
                }
            }.background(colorBackground).ignoresSafeArea()
       
//        Text("\(Text("Next Payment: ").foregroundColor(.gray)) \(Text(nextPaymentDate).bold().foregroundColor(.black))")
//
//        Spacer()
//        Text("\(Text("\(currentPaymentProgress)").foregroundColor(.black)) \(Text("of \(totalPayments) payments").foregroundColor(.gray))")
//            .padding(20)
    }
}

struct TextGridView : View {
    var item: Int
    var loanProject: LoanProject
    
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
            case "twoDigDec":
                numberFormatter.numberStyle = .currency
                numberFormatter.maximumFractionDigits = 2
            case "decimals": numberFormatter.numberStyle = .none
            case "ordinal": numberFormatter.numberStyle = .ordinal
            case "percent":
                numberFormatter.numberStyle = .percent
                numberFormatter.maximumFractionDigits = 2
            return numberFormatter.string(from: NSNumber(value: _value/100)) ?? "0"
            default: numberFormatter.numberStyle = .none
        }
        return numberFormatter.string(from: NSNumber(value: _value)) ?? "0"
    }
    
    var body : some View {
        VStack(alignment: .leading) {
            switch item {
            case 1:
                Text("\(Text("  Interest: \n \n").foregroundColor(.gray).font(.system(size: 12))) \(Text(formattedValue(_value: loanProject.loanDetails?.interestPaidToDate ?? 0, _case:"twoDigDec")).font(.system(size: 22)).bold().foregroundColor(.black))")
                    .frame(width: UIScreen.screenWidth/2.3, height: UIScreen.screenHeight/4.9, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .font(.title)
            case 2:
                Text("\(Text("  Interest Rate: \n \n").foregroundColor(.gray).font(.system(size: 12))) \(Text(formattedValue(_value: loanProject.loanDetails?.interestRate ?? 0, _case:"percent")).font(.system(size: 22)).bold().foregroundColor(.black))")
                    .frame(width: UIScreen.screenWidth/2.3, height: UIScreen.screenHeight/4.9, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .font(.title)
            case 3:
                let loanId = loanProject.loanDetails?.loanID ?? ""
                Text("\(Text("  Loan ID: \n \n").foregroundColor(.gray).font(.system(size: 12))) \(Text(loanId).font(.system(size: 22)).bold().foregroundColor(.black))")
                    .frame(width: UIScreen.screenWidth/2.3, height: UIScreen.screenHeight/4.9, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .font(.title)
            default:
                    NavigationLink(destination: LoanProjectDetailCard(loanProject: loanProject)) {
                       
                
                
                Text("\(Text("\n\n\n\n Upcoming \n Payments").font(.system(size: 12)).bold().foregroundColor(.white))")
                    .frame(width: UIScreen.screenWidth/2.3, height: UIScreen.screenHeight/4.9, alignment: .leading)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .font(.title)
                                .overlay(
                                    VStack{
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                                    withAnimation {
                                                        print("Test")
                                                    }
                                                }, label: {
                                                    Text(Image(systemName: "arrow.right"))
                                                        .font(.title)
                                                        .foregroundColor(Color.white)
                                                        .padding(2)
                                                        .background(Color.purple)
                                                        .clipShape(Circle())
                                                        .shadow(radius: 5)
                                                })
                                                
                                                .padding(2)
                                                .background(Color.purple)
                                                .clipShape(Circle())
                                                .shadow(radius: 5)

                                    }.frame(width: UIScreen.screenWidth/2.6, height: UIScreen.screenHeight/6, alignment: .topTrailing)
                                    })
                    }
               
            }
           
        }
    }
}

struct LoanDetailView_Previews: PreviewProvider {
    struct StatefulPreviewWrapper: View {
        @State private var testProject = LoanProject.testData
        
        var body: some View {
            LoanDetailView(loanProject: $testProject).edgesIgnoringSafeArea(.all)
        }
    }
    
    static var previews: some View {
        Group {
            NavigationView {
                StatefulPreviewWrapper()
                
            }
        }
    }
}
