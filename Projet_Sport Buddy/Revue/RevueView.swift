//
//  RevueView.swift
//  Projet_Sport Buddy
//
//  Created by BELHADDAD Lahbib on 26/09/2020.
//

import SwiftUI

struct RevueView: View {
    let evenementTab: [Evenement]
    let profilUser: Profil
    
    @State var afficherListeEvaluation: Bool = false
    //@State var nombreEvaluation: Int = 0
    
    var body: some View {
        ScrollView {
            VStack{
                Text("évaluation(s)")
                //Faire la moyenne des évaluation
                HStack{
                    HStack{
                        //affiche étoile pleine
                        //Text("\(String(format: "%.1f", MoyenneNombreEtoile()))")
                        ForEach(0..<Int(MoyenneNombreEtoile())) {_ in
                            Image(systemName: "star.fill")
                        }
                        //Text("\((MoyenneNombreEtoile() - Double(Int(MoyenneNombreEtoile()))).rounded())")
//                        ForEach(0..<Int(((MoyenneNombreEtoile() - Double(Int(MoyenneNombreEtoile()))).rounded()))) {_ in
//                            Image(systemName: "star.lefthalf.fill")
//                        }
                        //affiche étoile vide
                        ForEach(0..<(5 - Int(MoyenneNombreEtoile()))) {_ in
                            Image(systemName: "star")
                        }
                    }.foregroundColor(.yellow)
                    Spacer()
                    Button(
                        action: {
                            self.afficherListeEvaluation = true
                        },
                        label: {
                            Text("Lire (\(TotalNombreEvaluation()) évaluations)")
                        }
                    )
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
                }.padding()
                if afficherListeEvaluation {
                    VStack {
                        //liste des évaluations
                        ForEach(ListeEvenementOrgaPasse()) { evenement in
                            
                            ForEach(evenement.evaluation) { evaluation in
                                HStack {
                                    ForEach(0..<evaluation.nombreEtoile) { _ in
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                    }
                                    ForEach(0..<(5 - evaluation.nombreEtoile)) {_ in
                                        Image(systemName: "star")
                                            .foregroundColor(.yellow)
                                    }
                                    Text("\(evaluation.texte)")
                                }.padding()
                            }
                        }
                    }
                }
            }
        }
    }
    func ListeEvenementOrgaPasse() -> [Evenement] {
        //récupérer la liste des évènements organisé (orga + passé)
        var listeEvenementOrgaPasse: [Evenement] { return evenementTab.filter { (evenement) -> Bool in
            if evenement.organisateur == profilUser && evenement.dateEtHeure
                < Date() {
                return true
            } else {
                return false
            }
        }
        }
        return listeEvenementOrgaPasse
    }
    func MoyenneNombreEtoile() -> Double {
        let listeEvenementOrgaPasse: [Evenement] = ListeEvenementOrgaPasse()
        
        var sommeEtoile: Int = 0
        var nombreEvaluation: Int = 0
        for evenement in listeEvenementOrgaPasse {
            nombreEvaluation += evenement.evaluation.count
            for evaluation in evenement.evaluation {
                sommeEtoile += evaluation.nombreEtoile
            }
        }
        return Double(sommeEtoile) / Double(nombreEvaluation)
    }
    func TotalNombreEvaluation() -> Int {
        let listeEvenementOrgaPasse: [Evenement] = ListeEvenementOrgaPasse()
        
        var nombreEvaluation: Int = 0
        for evenement in listeEvenementOrgaPasse {
            nombreEvaluation += evenement.evaluation.count
        }
        return nombreEvaluation
    }
}

struct RevueView_Previews: PreviewProvider {
    static var previews: some View {
        RevueView(evenementTab: DataModel.shared.evenementTab, profilUser: DataModel.shared.profilTab[0])
    }
}
