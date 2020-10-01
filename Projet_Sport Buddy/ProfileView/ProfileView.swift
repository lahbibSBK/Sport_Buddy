//
//  ProfileView.swift
//  Projet_Sport Buddy
//
//

import SwiftUI
import MapKit

struct ProfileView: View {
    let profilUser: Profil
    let evenementTab: [Evenement]
    let profilTab: [Profil]
    
    @State var message: String = ""
    @State var isUtilisateur: Bool = true
    @State var autorisationAgenda: Bool = true
    
    var body: some View {
        NavigationView {
        VStack {
            Form {
                //Partie commune autre profil et mon profil
                HStack(alignment: .center){
                    Spacer()
                Section {
                        Text(profilUser.avatar)
                            .font(.system(size: 100))
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                    }
                    Spacer()
                }
                Section {
                    HStack{
                        Text(profilUser.pseudo)
                        Spacer()
                        Text("\(profilUser.age) ans")
                    }.padding()
                    HStack{
                        Text(profilUser.bio)
                        Spacer()
                        Text(profilUser.sexe)
                    }.padding()
                }
                //Liste des sports préférés et des niveaux associés
                Section {
                    VStack(alignment: .leading){
                        HStack{
                            Text("Mes sports préférés :")
                            Spacer()
                        }
                        
                        ForEach(profilUser.sportsPreferes) { sport in
                            HStack{
                                Text("\(sport.sport.sportIcone)")
                                    .font(.system(size: 30))
                                Text("\(sport.sport.nomSport)")
                                Spacer()
                                NiveauSportPrefere(level: sport.niveau)
                                    .frame(width: 30, height: 60)
                            }.padding()
                        }
                    }.padding()
                }
                //faire une section lorsque c'est le profil de l'utilisateur
                //if user afficher bouton autoriser accès agenda sinon envoyer message...
                Section {
                    if profilUser == profilTab[0] {
                        Section {
                            HStack{
                                Toggle("Autoriser accès agenda", isOn: $autorisationAgenda)
                            }
                        }
                    } else {
                        EcrireMessage()
                    }
                    Spacer()
                    Section {
                        RevueView(evenementTab: evenementTab, profilUser: profilUser)
                    }
                }.padding()
            }
        }//V
        .navigationBarItems(trailing: Image(systemName: "wrench")
                                .font(.system(size: 20))
                                .foregroundColor(.blue))
        }
    }
    func EvaluationProfil() -> [Evenement] {
        //récupérer la liste des évènements organisé (orga + passé)
        var listeEvenementOrga: [Evenement] { return evenementTab.filter { (evenement) -> Bool in
            if evenement.organisateur == profilUser {
                return true
            } else {
                return false
            }
        }
        }
        
        var listeEvenementOrgaPasse: [Evenement] { return listeEvenementOrga.filter { (evenement) -> Bool in
            if evenement.dateEtHeure
                < Date() {
                return true
            } else {
                return false
            }
        }
        }
        
        return listeEvenementOrgaPasse
    }
    func CalculEvaluation() -> Int {
        let listeEvenementOrgaPasse: [Evenement] = EvaluationProfil()
        
        var sommeEtoile: Int = 0
        var nombreEvaluation: Int = 0
        for evenement in listeEvenementOrgaPasse {
            nombreEvaluation += evenement.evaluation.count
            for evaluation in evenement.evaluation {
                sommeEtoile += evaluation.nombreEtoile
            }
        }
        return sommeEtoile / nombreEvaluation
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profilUser: DataModel.shared.profilUser, evenementTab: DataModel.shared.evenementTab, profilTab: DataModel.shared.profilTab)
    }
}


