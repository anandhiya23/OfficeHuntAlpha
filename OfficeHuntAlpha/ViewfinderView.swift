/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct ViewfinderView: View {
    @Binding var image: Image?
    var cornerRadius: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .clipped()
            }
        }
    }
}

struct ViewfinderView_Previews: PreviewProvider {
    static var previews: some View {
        ViewfinderView(image: .constant(Image(systemName: "pencil")))
    }
}
