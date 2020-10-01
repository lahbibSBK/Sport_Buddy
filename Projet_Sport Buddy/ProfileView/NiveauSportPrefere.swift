import SwiftUI

struct NiveauSportPrefere: View {
    var level: Int
    var body: some View {
        HStack(alignment: .bottom, spacing: 4.0){
            VStack{
                Spacer()
                Spacer()
                Rectangle()
                    .foregroundColor(.black)
            }
            VStack {
                Spacer()
                Rectangle()
                    .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .foregroundColor( level >= 2 ? .black : .white)
            }
            Rectangle()
                .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .foregroundColor( level == 3 ? .black : .white)
        }.frame(width: 25, height: 25)
        
    }
}

struct NiveauSportPrefere_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            NiveauSportPrefere(level: 3)
        }
    }
}
