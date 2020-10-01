//
//  FiltreRecherche.swift
//  Projet_Sport Buddy
//
//

import SwiftUI

struct FiltreRecherche: View {
    @State var evenementTab: [Evenement]
    let profilUser: Profil
    let profilTab: [Profil]
    
    var isRecherche: Bool
    @Binding var filtreVariable: Filtre
    @Binding var modalePresent: Bool
    
    @State private var placeLibre: Bool = false
    @State private var rayonDeRecherche: Int = 10
    @State private var niveauxAcceptes: Int = 0
    @State private var lieuEvenement: Bool = true
    @State private var lieuCreation: String = ""
    @State private var lieuCreation2: Lieu = Lieu(nom: "Parc Blandan", latitude: 45.74449, longitude: 4.853691)
    @State private var dateEvenement = Date()
    @State private var orga: String = ""
    @State private var descriptionEvenement: String = ""
    @State private var participantMax: Int = 2
    
    @State var listeSports =
        [ListeSport(sportIcone: "", nomSport: "Tous"), ListeSport(sportIcone: "⚽️", nomSport: "Football"), ListeSport(sportIcone: "🏀", nomSport: "Basketball"), ListeSport(sportIcone: "🏈", nomSport: "Rugby"), ListeSport(sportIcone: "🎾", nomSport: "Tennis"), ListeSport(sportIcone: "🏐", nomSport: "Volley"), ListeSport(sportIcone: "🥏", nomSport: "Freezebe"), ListeSport(sportIcone: "🏓", nomSport: "PingPong"), ListeSport(sportIcone: "🏸", nomSport: "Badminton"), ListeSport(sportIcone: "🏒", nomSport: "Hockey"), ListeSport(sportIcone: "🥊", nomSport: "Boxe"), ListeSport(sportIcone: "🧘🏽‍", nomSport: "Yoga"), ListeSport(sportIcone: "🏊🏽‍♂️", nomSport: "Natation"), ListeSport(sportIcone: "🚴🏽‍", nomSport: "Cyclisme"), ListeSport(sportIcone: "🧗🏾‍♀️", nomSport: "Escalade"), ListeSport(sportIcone: "🥋", nomSport: "Judo"), ListeSport(sportIcone: "🏃🏽", nomSport: "Course à Pieds")]
    let listeRayons: [String] = ["2", "5", "10", "20"]
    let niveaux: [String] = ["débutant", "intermédiaire", "professionnel"]
    //récupérer la liste des profilTab avatar
    let avatarTab: [String] = ["🤠", "🤡", "💩", "👻", "🤖", "😺", "👧🏼", "🧒🏽", "👩🏾", "👳🏽‍♂️", "🧕🏿", "👲🏽", "🧑🏽‍🎤"]
    
    //trouver une expression pour créer un tableau [2...50]
    @State var nombreParticipant: [Int] = [2, 3, 4, 5, 6, 7, 8,9, 10,11,12, 13,14,15,16]
    
    @State private var selectedSportIndex = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack{
                    Form {
                        Section {
                            Picker(selection: $selectedSportIndex, label: Text("Sport")) {
                                ForEach(0 ..< listeSports.count) {
                                    Text("\(self.listeSports[$0].sportIcone) - \(self.listeSports[$0].nomSport)")
                                }
                            }
                        }
                        Section {
                            Text("Date - Heure")
                            DatePicker("Choisir une Date et une heure", selection: $dateEvenement)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .frame(maxHeight: 400)
                            Picker(selection: $niveauxAcceptes, label: Text("Niveaux Acceptés")) {
                                ForEach(0 ..< niveaux.count) {
                                    Text(self.niveaux[$0])
                                }
                            }
                        }
                        if isRecherche {
                            Section {
                                //pour choisir uniquement les évènements qui ont des places libres ou acceptent sur liste d'attente
                                Toggle("Inclure les évènements complets (liste d'attente)", isOn: $placeLibre)
                                Toggle("Lieu (utiliser ma position GPS)", isOn: $lieuEvenement)
                                Picker(selection: $rayonDeRecherche, label: Text("Rayon (km)")) {
                                    ForEach(0 ..< listeRayons.count) {
                                        Text(self.listeRayons[$0])
                                    }
                                }
                                Picker(selection: $orga, label: Text("Organisateur")) {
                                    ForEach(0 ..< avatarTab.count) {
                                        Text(self.avatarTab[$0])
                                    }
                                }
                            }
                        } else {
                            Section {
                                TextField("Lieu", text: $lieuCreation)
                                Picker(selection: $participantMax, label: Text("Nombre de Participants Max")) {
                                    ForEach(2 ..< nombreParticipant.count) {
                                        Text("\( self.nombreParticipant[$0])")
                                    }
                                }
                            }
                            TextField("Description", text: $descriptionEvenement)
                        }
                    }//Form
                    
                    
                    
                }//Vstack
                .navigationBarItems(leading: searchButton,
                    trailing: Button("annuler") {
                    modalePresent = false
                })
               
            }//Z
        }//Nav
    }
   
    
    @ViewBuilder var searchButton: some View {
        if isRecherche {
            //Changer la destination pour MapRechercheView avec evenementTab et filtre variable en arguments
            Button( action: {
                filtreVariable = CreationVariableFiltre()
                modalePresent = false
                
            }, label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 40, height: 40)
            })
        } else {
            Button(
                action: {
                    //MesEvenementsView()
                    //fonction qui crée et ajoute l'évenement à evenementTab
                    CreationNouvelEvenement()
                    modalePresent = false
                },
                label: {
                    Text("Créer")
                }
            )
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            
        }

    }
    
    func CreationNouvelEvenement() {
        //création d'une nouvelle variable evenement
        
        let nouvelEvenement: Evenement = Evenement(organisateur: profilUser, sport: listeSports[selectedSportIndex], niveau: niveauxAcceptes, dateEtHeure: dateEvenement, description: descriptionEvenement, lieu: lieuCreation2, participantMax: participantMax, participantsInscrits: [profilUser], participantsInscritsListeDAttente: [profilUser], evaluation: [Evaluation(nombreEtoile: 1, texte: "String", participant: profilUser)])
        //ajout dans evenementTab
        self.evenementTab.append(nouvelEvenement)
    }
    //fonction qui modifie la variable filtre
    func CreationVariableFiltre()-> Filtre {
        return Filtre(sport: listeSports[selectedSportIndex], date: dateEvenement, niveau: niveauxAcceptes, placeLibre: placeLibre, lieu: lieuCreation2, rayon: rayonDeRecherche)
        //MapRechercheView()
    }
}

struct FiltreRecherche_Previews: PreviewProvider {
    static var previews: some View {
        FiltreRecherche(evenementTab: DataModel.shared.evenementTab, profilUser: DataModel.shared.profilUser, profilTab: DataModel.shared.profilTab ,isRecherche: DataModel.shared.isRecherche, filtreVariable: .constant(DataModel.shared.filtreVariable), modalePresent: .constant(true))
    }
}
