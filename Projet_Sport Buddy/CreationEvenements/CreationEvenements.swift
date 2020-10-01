//
//  CreationEvenements.swift
//  Projet_Sport Buddy
//
//

import SwiftUI

struct CreationEvenements: View {
    @State var lieu: String = ""
    @State var isPrivate: Bool = true
    
    var body: some View {
        
            NavigationView {
                Form {
                    Section(header: Text("Section 1")) {
                        TextField("Lieu", text: $lieu)
                        Toggle(isOn: $isPrivate) {
                            Text("Private Account")
                        }
                    }
                }
                .navigationBarTitle("Création évènement")
            }
    }
}

struct CreationEvenements_Previews: PreviewProvider {
    static var previews: some View {
        CreationEvenements()
    }
}
