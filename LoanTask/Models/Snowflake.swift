
import SwiftUI

struct Snowflake: Shape {
    func path(in rect: CGRect) -> Path {
        var mainPath = Path()
        
        let width: CGFloat = rect.size.width
        let height: CGFloat = rect.size.height
        
        let centerX = width / 2
        let centerY = height / 2
        let stemStart = height * 0.15
        let stemEndY = height * 0.05
        let leadingStemEndX = width * 0.35
        let trailingStemEndX = width * 0.65
        
        var snowflakeBranch = Path()
        // A branch of the snowflake
        snowflakeBranch.move(to: CGPoint(x: centerX, y: 0))
        snowflakeBranch.addLine(to: CGPoint(x: centerX, y: centerY))
        
        snowflakeBranch.move(to: CGPoint(x: centerX, y: stemStart))
        snowflakeBranch.addLine(to: CGPoint(x: leadingStemEndX, y: stemEndY))
        
        snowflakeBranch.move(to: CGPoint(x: centerX, y: stemStart))
        snowflakeBranch.addLine(to: CGPoint(x: trailingStemEndX, y: stemEndY))
        
        for branchNumber in 1...6 {
            let rotationAngle = Angle(degrees: Double(branchNumber)/Double(6) * 360)
            
            let rotationTransformation = CGAffineTransform.identity
                .translatedBy(x: centerX, y: centerY)
                .rotated(by: CGFloat(rotationAngle.radians))
                .translatedBy(x: -centerX, y: -centerY)
            
            let rotatedBranch = snowflakeBranch.applying(rotationTransformation)
            
            mainPath.addPath(rotatedBranch)
        }
        
        return mainPath
    }
}

struct Snowflake_Previews: PreviewProvider {
    static var previews: some View {
        Snowflake()
            .stroke(Color.accentColor, lineWidth: 5)
            .frame(width: 400, height: 400)
            .border(Color.blue)
    }
}
