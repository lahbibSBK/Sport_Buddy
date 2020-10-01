//
//  MesEvenementsView.swift
//  Projet_Sport Buddy
//
//

import SwiftUI

struct MesEvenementsView: View {
    let profilUser: Profil
    let evenementTab: [Evenement]
    let profilTab: [Profil]
    @State var filtreVariable: Filtre
    
    @State private var ongletSelectionne = 0
    @State var listeEvenementCree: [Evenement] = []
    @State var modalePresent = false
    
    
    var body: some View {
        //affiche la liste
        NavigationView {
            ZStack {
                VStack{
                    VStack{
                        //Affiche le segmented bar (suggestion/Inscrit/ Créé(s)
                        Picker(selection: $ongletSelectionne, label: Text("")) {
                            Text("Suggestion").tag(0)
                            Text("Inscrit").tag(1)
                            Text("Créé(s)").tag(2)
                        }.pickerStyle(SegmentedPickerStyle())
                        if ongletSelectionne == 0 {
                            if triEvenementSuggestion().count != 0 {
                                List(triEvenementSuggestion()) { evenement in
                                    NavigationLink(destination: FicheInfoEvenements(evenement: evenement, evenementTab: evenementTab, profilUser: profilUser, profilTab: profilTab)) {
                                        
                                        Text("\t\(evenement.sport.sportIcone)\t\t\(evenement.organisateur.avatar)\t\t \(printDate(date: evenement.dateEtHeure))")
                                    }
                                }
                            }
                            else {
                                Text("Pas de suggestion : Modifiez vos sports préférés")
                            }
                        } else if ongletSelectionne == 1 {
                            HStack{
                                Text("à Venir")
                                Spacer()
                            }.padding()
                            List(triEvenementInscritFutur()) { evenement in
                                NavigationLink(destination: FicheInfoEvenements(evenement: evenement, evenementTab: evenementTab, profilUser: profilUser, profilTab: profilTab)) {
                                    
                                    Text("\t\(evenement.sport.sportIcone)\t\t\(evenement.organisateur.avatar)\t\t\(printDate(date: evenement.dateEtHeure))")
                                }
                            }
                            HStack{
                                Text("Passé(s)")
                                Spacer()
                            }.padding()
                            List(triEvenementInscritPasse()) { evenement in
                                NavigationLink(destination: FicheInfoEvenements(evenement: evenement, evenementTab: evenementTab, profilUser: profilUser, profilTab: profilTab)) {
                                    
                                    Text("\t\(evenement.sport.sportIcone)\t\t\(evenement.organisateur.avatar)\t\t\(printDate(date: evenement.dateEtHeure))")
                                }
                            }
                        } else if ongletSelectionne == 2 {
                            HStack{
                                Text("à Venir")
                                Spacer()
                            }.padding()
                            List(triEvenementOrgaFutur()) { evenement in
                                NavigationLink(destination: FicheInfoEvenements(evenement: evenement, evenementTab: evenementTab, profilUser: profilUser, profilTab: profilTab)) {
                                    
                                    Text("\t\(evenement.sport.sportIcone)\t\t\(printDate(date: evenement.dateEtHeure))\t\t\(evenement.participantsInscrits.count)/\(evenement.participantMax)\t\t\(evenement.participantsInscritsListeDAttente.count)")
                                }
                            }
                            HStack{
                                Text("Passé(s)")
                                Spacer()
                            }.padding()
                            List(triEvenementOrgaPasse()) { evenement in
                                NavigationLink(destination: FicheInfoEvenements(evenement: evenement, evenementTab: evenementTab, profilUser: profilUser, profilTab: profilTab)) {
                                    
                                    Text("\t\(evenement.sport.sportIcone)\t\t\(printDate(date: evenement.dateEtHeure))\t")
                                }
                            }
                        }
                        
                    } //Vs
                    //affiche le titre de naviagation de la view
                    .navigationBarTitle("Mes Evènements")
                    .navigationBarItems(trailing:
                                            Button(action: {
                                                self.modalePresent = true
                                            }, label: {
                                                Image(systemName: "plus.circle.fill").font(.title)
                                            })
                    )
                    Spacer()
                } //Vs
            }//Z
        }//navi
        .sheet(isPresented: $modalePresent, content: {
            FiltreRecherche(evenementTab: evenementTab, profilUser: profilUser, profilTab: profilTab,isRecherche: false, filtreVariable: $filtreVariable, modalePresent: $modalePresent)})
        }
    
    //fonction qui renvoit la liste des évènements I'm in
    func triEvenementInscrit() -> [Evenement] {
        
        var listeEvenementInscrit: [Evenement] { return evenementTab.filter { (evenement) -> Bool in
            if evenement.participantsInscrits
                .contains(profilUser) {
                return true
            } else {
                return false
            }
        }
        }
        return listeEvenementInscrit
    }
    //fonction qui renvoit la liste des évènements I'm in dont la date est passée
    func triEvenementInscritPasse() -> [Evenement] {
        let listeEvenementInscrit: [Evenement] = triEvenementInscrit()
        
        var listeEvenementInscritPasse: [Evenement] { return listeEvenementInscrit.filter { (evenement) -> Bool in
            if evenement.dateEtHeure
                < Date() {
                return true
            } else {
                return false
            }
        }
        }
        return listeEvenementInscritPasse
    }
    //fonction qui renvoit la liste des évènements I'm in dont la date n'est pas encore passée
    func triEvenementInscritFutur() -> [Evenement] {
        let listeEvenementInscrit: [Evenement] = triEvenementInscrit()
        
        var listeEvenementInscritFutur: [Evenement] { return listeEvenementInscrit.filter { (evenement) -> Bool in
            if evenement.dateEtHeure
                >= Date() {
                return true
            } else {
                return false
            }
        }
        }
        return listeEvenementInscritFutur
    }
    //fonction qui renvoit la liste des évènements créés
    func triEvenementOrga() -> [Evenement] {
        
        var listeEvenementOrga: [Evenement] { return evenementTab.filter { (evenement) -> Bool in
            if evenement.organisateur == profilUser {
                return true
            } else {
                return false
            }
        }
        }
        return listeEvenementOrga
    }
    //fonction qui renvoit la liste des évènements créés dont la date est passée
    func triEvenementOrgaPasse() -> [Evenement] {
        let listeEvenementOrga: [Evenement] = triEvenementOrga()
        
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
    //fonction qui renvoit la liste des évènements créés qui dont la date n'est pas encore passée
    func triEvenementOrgaFutur() -> [Evenement] {
        let listeEvenementOrga: [Evenement] = triEvenementOrga()
        
        var listeEvenementOrgaFutur: [Evenement] { return listeEvenementOrga.filter { (evenement) -> Bool in
            if evenement.dateEtHeure
                >= Date() {
                return true
            } else {
                return false
            }
        }
        }
        return listeEvenementOrgaFutur
    }
    //fonction qui renvoit la liste des évènements qui correspondent aux sport préférés
    //exclure les évènements créés et inscrit et passé et complet
    func triEvenementSuggestion() -> [Evenement] {
        var listeEvenementSuggestion: [Evenement] { return evenementTab.filter { (evenement) -> Bool in
            // && thereseProfil[0].sportsPreferes[0][0].contains(evenement.sport)
            if !evenement.participantsInscrits
                .contains(profilUser) && evenement.organisateur != profilUser && evenement.dateEtHeure >= Date() && evenement.participantsInscrits.count == evenement.participantMax {
                return true
            } else {
                return false
            }
        }
        }
        return listeEvenementSuggestion
    }
    
    func printDate(date: Date) -> String {
        let dateFormatter       = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale    = Locale(identifier: "FR-fr")
        return dateFormatter.string(from: date)
    }
}

struct MesEvenementsView_Previews: PreviewProvider {
    static var previews: some View {
        MesEvenementsView(profilUser: DataModel.shared.profilUser, evenementTab: DataModel.shared.evenementTab, profilTab: DataModel.shared.profilTab, filtreVariable: DataModel.shared.filtreVariable)
    }
}

