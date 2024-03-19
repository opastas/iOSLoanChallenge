
import SwiftUI

struct ProjectProgressView: View {
    var amountBorrowed: Double
    var amountLeft: Double
    
    func formattedProgressValue(_value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: _value)) ?? "0"
    }
    
    var body: some View {
        ZStack (alignment: .bottomLeading) {
            if #available(iOS 15.0, *) {
                Color(uiColor: UIColor.systemGray3).ignoresSafeArea()
            } else {
                // Fallback on earlier versions
                Color.gray.ignoresSafeArea()
            }
            VStack() {
                HStack {
                    if #available(iOS 15.0, *) {
                        Text("Left: ").bold().dynamicTypeSize(.small)
                        Text("\(formattedProgressValue(_value: amountLeft))").dynamicTypeSize(.small)
                    } else {
                        // Fallback on earlier versions
                        Text("Left: ").bold()
                        Text("\(formattedProgressValue(_value: amountLeft))")
                    }
                    Spacer()
                    if #available(iOS 15.0, *) {
                    Text("Amount Borrowed: ").bold().dynamicTypeSize(.small)
                    Text("\(formattedProgressValue(_value: amountBorrowed))").dynamicTypeSize(.small)
                    } else {
                        // Fallback on earlier versions
                        Text("Amount Borrowed: ").bold()
                        Text("\(formattedProgressValue(_value: amountBorrowed))")
                    }
                }.padding(.horizontal)
        HStack {
            GeometryReader { geometryProxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .opacity(0.3)
                        .foregroundColor(.white)
                    
                    Capsule()
                        .opacity(1.0)
                        .foregroundColor(.green)
                        // Want this to be a percentage of the width, but to do that, you need to know how wide the parent view where it's used has offered.  That's where GeometryReader comes in -- it allows this View to know how much space, in terms of width and height, that the parent has offered a child. With this information, the child can use it to choose its size __based on__ that available space rather than just following the default SwiftUI rules.
                        .frame(width: geometryProxy.size.width * CGFloat((amountBorrowed-amountLeft)/amountBorrowed), height: geometryProxy.size.height)
                    
                    if amountBorrowed > 0.0 {
                        Snowflake()
                            .stroke(Color.white)
                            .frame(width: geometryProxy.size.height - 2 , height: geometryProxy.size.height - 2)
                            .offset(x: (geometryProxy.size.width * CGFloat((amountBorrowed-amountLeft)/amountBorrowed)) - geometryProxy.size.height)
                            
                    }
                }.animation(.spring(response: 1, dampingFraction: 0.75), value: self.amountBorrowed)
            }
            .frame(maxHeight: 20)
            Spacer()
        }
            }
        }.frame(height: UIScreen.screenWidth / 4)
            .background(Color.gray).ignoresSafeArea()
    }
}

struct ProjectProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectProgressView(amountBorrowed: 3250, amountLeft: 652)
    }
}
