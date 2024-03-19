
import SwiftUI

struct MenuItemCard: View {
    let menuItem: MenuItem
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(menuItem.title).foregroundColor(.black).bold()
                            .font(.system(size: 12))
                        if (menuItem.title == MenuItem.viewSavedDocs) {
                            Text("\(menuItem.specificDetail) \(menuItem.detailMsg)")
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        } else {
                            Text("\(menuItem.detailMsg)\(menuItem.specificDetail)")
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                        
                    }
                    Spacer()
                    Button(action: {
                        withAnimation {
                            print("\(menuItem.title)")
                        }
                    }, label: {
                        Text(Image(systemName: menuItem.systemImage))
                            .font(.title)
                            .foregroundColor(Color.white)
                            .padding(2)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    })
                    
                    .padding(2)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                }
            }.padding()
            Divider().opacity(0)
        }.foregroundColor(.white).cornerRadius(20).frame(width: UIScreen.screenWidth/1.2, height: 70, alignment: .leading)
    }
}

struct MenuItemCard_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemCard(menuItem: MenuItem.menuItemData[0])
    }
}
