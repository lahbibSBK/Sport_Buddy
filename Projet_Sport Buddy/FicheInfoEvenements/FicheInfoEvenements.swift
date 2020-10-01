//
//  FicheInfoEvenements.swift
//  Projet_Sport Buddy
//
//

import SwiftUI
import MapKit

struct FicheInfoEvenements: View {
    @State var evenement: Evenement
    let evenementTab: [Evenement]
    let profilUser: Profil
    let profilTab: [Profil]
    //à modifier mettre un message dans l'évènement
    @State var message: String = ""
    @State var isUtilisateur: Bool = true
    //Modifier les valeurs pour modifier l'affichage
    // bouton I'm in = true, true, true
    // bouton annuler inscription = false, true, true
    // bouton revue = false, false, true
    @State var nonInscrit: Bool = true
    @State var datePasPassee: Bool = true
    @State var nonOrganisateur: Bool = true
    @State var acceptationAutomatique: Bool = false
    @State var presentedParticipant: Profil?
    @Environment(\.presentationMode) var mode
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.75, longitude: 4.85), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    func printDate(date: Date) -> String {
        let dateFormatter       = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale    = Locale(identifier: "FR-fr")
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        VStack{
            Form {
                Section {
                    VStack{
                        Map(coordinateRegion: $region)
                            .frame(width: 320, height: 250)
                        Text("\(printDate(date: evenement.dateEtHeure))")
                    }.padding()
                }
                
                Section {
                    organisateurView
                }
                
                Section {
                    VStack{
                        Text("Infos évènement :")
                        //Afficher un texte dans un rectangle de dim fixe
                        Text(evenement.description)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke())
                    }.padding()
                    
                    participantsView.buttonStyle(PlainButtonStyle())
                    
                    HStack{
                        Text("Liste d'Attente : \(evenement.participantsInscritsListeDAttente.count)")
                        List(evenement.participantsInscritsListeDAttente) { inscrit in
                            Text("\(inscrit.avatar)")
                        }
                    }.padding()
                }
                Section {
                    EcrireMessage()
                }
                //Vérification si l'utilisateur est inscrit à l'évènement
                //nonInscrit = evenement.participantsInscrits.contains(profilTab[0]) ? false : true
                
                //Est-ce que je ne suis pas déjà inscrit et si date pas encore passée et pas organisateur = true && true && true
                //datePasPassee = evenement.dateEtHeure < Date() ? true : false
                /*if true {
                 CheckCondition()
                 
                 }*/
                Section {
                    if !evenement.participantsInscrits.contains(profilTab[0]) && evenement.dateEtHeure >= Date() && !(evenement.organisateur == profilTab[0]) {
                        //Pour les évènement suggestion
                        HStack{
                            Button(
                                action: {
                                    ajouterParticipation()
                                    mode.wrappedValue.dismiss()
                                    //Renvoyer vers ongletSelectionne = 1, avec mise à jour des données
                                },
                                label: {
                                    Text("Inscription")
                                }
                            )
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                    } else if evenement.participantsInscrits.contains(profilTab[0]) && evenement.dateEtHeure < Date() && !(evenement.organisateur == profilTab[0]) {
                        //si je suis inscrit et si la date est passée et pas organisateur = false && false
                        //proposer la revue de l'évènement. Inscrit et passé
                        VStack{
                            Text("Revue")
                            //Choisir le nombre d'étoiles
                            HStack{
                                HStack{
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star")
                                    Image(systemName: "star")
                                }.foregroundColor(.yellow)
                                Spacer()
                                Button(
                                    action: {
                                        //enregistrer la revue dans évènement
                                        mode.wrappedValue.dismiss()
                                    },
                                    label: {
                                        Text("Valider")
                                    }
                                )
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                            }.padding()
                        }.padding()
                    } else if evenement.dateEtHeure >= Date() && evenement.organisateur == profilTab[0] {
                        //je suis l'organisateur
                        //affichage de gestion d'évènement
                        VStack {
                            Toggle("Accepter automatiquement les participants", isOn: $acceptationAutomatique)
                            List(evenement.participantsInscrits) { participant in
                                NavigationLink(destination: ProfileView(profilUser: participant, evenementTab: evenementTab, profilTab: profilTab)) {
                                    HStack {
                                        Text("\(participant.avatar)")
                                        Text("\(participant.pseudo)")
                                        Toggle("Accepter", isOn: $acceptationAutomatique)
                                    }
                                }
                            }
                            /*ForEach(evenement.participantsInscrits) { participant in
                             HStack{
                             Text("\(participant.pseudo)")
                             Image(systemName: participant.avatar)
                             }.padding()
                             }*/
                        }.padding()
                    } else if evenement.participantsInscrits.contains(profilTab[0]) && evenement.dateEtHeure >= Date() && !(evenement.organisateur == profilTab[0]) {
                        //si je suis inscrit et que la date n'est pas encore passée et pas organisateur
                        Button(
                            action: {
                                //Renvoyer vers ongletSelectionne = 1, avec mise à jour des données, l'évènement ne s'affiche plus
                                supprimerParticipation()
                                mode.wrappedValue.dismiss()
                                
                            },
                            label: {
                                Text("Désinscription")
                            }
                        )
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                    }
                }
            }
            profilNav
        }//V
    }
    
    var profilNav: some View {
    NavigationLink(
        destination: presentedView,
        isActive: .init(get: {
                            presentedParticipant != nil
            
        },
                       
        set: {newvalue in
                            if newvalue == false { presentedParticipant = nil
                                
                            }}),
        label: {
            EmptyView()
        })
    }
    
    
    @ViewBuilder var presentedView: some View {
        if let presentedParticipant = presentedParticipant {
        ProfileView(profilUser: presentedParticipant, evenementTab: evenementTab, profilTab: profilTab)
        } else {
            EmptyView()
        }
    }
    
    var organisateurView: some View {
        VStack{
            HStack {
                Text("Organisateur : ")
                Spacer()
            }
            HStack{
                NavigationLink(destination: ProfileView(profilUser: evenement.organisateur, evenementTab: evenementTab, profilTab: profilTab)) {
                    
                    Text("\(evenement.organisateur.avatar) \(evenement.organisateur.pseudo)")
                        .font(.system(size: 20))
                }
                Spacer()
                Text(evenement.sport.sportIcone)
                    .font(.system(size: 40))
                NiveauSportPrefere(level: 3)
            }.padding()
        }.padding()
    }
    
    var participantsView: some View {
        VStack(alignment: .leading, spacing: 10.0){
       
                Text("Participant(s) : \(evenement.participantsInscrits.count)/\(evenement.participantMax)")
               
                HStack{
                    ForEach(evenement.participantsInscrits) { inscrit in
                        Button(inscrit.avatar) {
                            presentedParticipant = inscrit
                        }
                    }
                }.buttonStyle(PlainButtonStyle()) //H
                
                
            
        }.padding()
    }
    
    
    func CheckCondition(){
        nonInscrit = evenement.participantsInscrits.contains(profilTab[0]) ? false : true
        datePasPassee = evenement.dateEtHeure >= Date() ? true : false
        nonOrganisateur = evenement.organisateur == profilTab[0] ? false : true
    }
    //Supprime l'utilisateur de la liste des participants == Désinscription
    func supprimerParticipation() {
        //evenement.participantsInscrits.remove(at: profilUser)
    }
    //Ajoute l'utilisateur à la liste des participants == Inscription
    func ajouterParticipation() {
        evenement.participantsInscrits.append(profilUser)
    }
    func LieuFicheInfoEvenement()-> TypeDeLieux {
        return TypeDeLieux(nom: evenement.lieu.nom, latitude: evenement.lieu.latitude, longitude: evenement.lieu.longitude, etiquette: evenement.sport.sportIcone)
    }
}

struct FicheInfoEvenements_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FicheInfoEvenements(evenement: DataModel.shared.evenementTab[2], evenementTab: DataModel.shared.evenementTab, profilUser: DataModel.shared.profilUser,profilTab: DataModel.shared.profilTab)
        }
    }
}
