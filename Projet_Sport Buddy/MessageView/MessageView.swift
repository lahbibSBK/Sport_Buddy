//
//  Message.swift
//  Projet_Sport Buddy
//
//

import SwiftUI


struct MessageView: View {
    let profilUser: Profil
    let messageTab: [Message]
    var body: some View {
            VStack{
                HStack {
                    Spacer()
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }.padding()
                List(messageTab) { message in
                    VStack{
                        HStack{
                            Text("\(message.expediteur.avatar)")
                            Text("\(message.expediteur.pseudo)")
                                .font(.title2)
                                Spacer()
                        }
                        HStack {
                        Text("\(message.sujet)")
                            .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                }
                .navigationBarTitle("Messages")
            }
    }
}

struct Message_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(profilUser: DataModel.shared.profilTab[0], messageTab: DataModel.shared.messageTab)
    }
}


struct EcrireMessage: View {
    @State var message: String = ""
    
    var body: some View {
        Section {
            Text("Message")
            HStack{
                VStack{
                    Text("Envoyer un message :")
                    Form {
                        TextField("Message", text: $message)
                    }
                }.padding()
                Button(
                    action: {
                        //vers une view Review
                    },
                    label: {
                        Image(systemName: "arrowtriangle.right")
                    }
                )
            }.padding()
        }
    }
}
