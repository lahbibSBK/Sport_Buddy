//
//  MapRechercheView.swift
//  Projet_Sport Buddy
//
//

import SwiftUI
import MapKit

struct MapRechercheView: View {
    let evenementTab: [Evenement]
    let profilUser: Profil
    let profilTab: [Profil]
    @State var filtreVariable: Filtre
    
    @State var modalePresent = false
    var evenementTabTri: [Evenement] = []
    var LieuSport: [TypeDeLieux] {
        let evenementTrie = triEvenementVsFiltre()
        return evenementTrie.map { (evenement) in
            TypeDeLieux(nom: evenement.lieu.nom, latitude: evenement.lieu.latitude, longitude: evenement.lieu.longitude, etiquette: evenement.sport.sportIcone)
        }
    }
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.75, longitude: 4.85), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var body: some View {
        NavigationView {
            ZStack{
                Map(coordinateRegion: $region,
                    annotationItems: LieuSport) { place in
                    
                    MapAnnotation(coordinate: place.coordinate) {
                        Text(place.etiquette)
                    }
                }
                .edgesIgnoringSafeArea(.all)
                //affiche un fake au centre de la carte pour la présentation
                VStack{
                    Text(".")
                    if triEvenementVsFiltre().count != 0 {
                    NavigationLink(destination: FicheInfoEvenements(evenement: triEvenementVsFiltre()[0], evenementTab: evenementTab, profilUser: profilUser, profilTab: profilTab)) {
                        Text("\(triEvenementVsFiltre()[0].sport.sportIcone)")
                    }
                }
                }.padding()
            }
            .navigationBarTitle("Carte")
            .navigationBarItems(trailing: filtreBouton)
        }//Nav
        .sheet(isPresented: $modalePresent, content: {
            FiltreRecherche(evenementTab: evenementTab, profilUser: profilUser, profilTab: profilTab,isRecherche: true, filtreVariable: $filtreVariable, modalePresent: $modalePresent)
        })
    }
    
    @ViewBuilder var filtreBouton: some View {
        
            Button( action: {
                modalePresent = true
            }, label: {
                Image(systemName: "slider.vertical.3")
                    .resizable()
                    .frame(width: 40, height: 40)
            })
    }
    
    //créer une fonction qui trie le tableau evenementTab vs les filtres
    func triEvenementVsFiltre() -> [Evenement] {
        //prendre les paramètres de la variable filtre et les mettre dans tableau
        //faire une boucle pour ne trier que sur les élèments du tableau
        //si filtre vide, evenementTab complet
        /*if ((filtreVariable.sport?.isEmpty) != nil) && filtreVariable.niveau != nil && filtreVariable.date != nil && filtreVariable.lieu != nil && filtreVariable.placeLibre != nil && filtreVariable.rayon != nil {
         return evenementTab
         }*/
        var listeEvenementTri: [Evenement] = []
        //si le filtre est vide renvoyer evenementTab
        if filtreVariable.sport?.sportIcone != "" {
        var listeEvenementTriTemp: [Evenement] { return evenementTab.filter { (evenement) -> Bool in
            
            if evenement.sport.sportIcone == filtreVariable.sport?.sportIcone && evenement.dateEtHeure >= Date() && evenement.participantsInscrits.count < evenement.participantMax && evenement.niveau >= filtreVariable.niveau! {
                return true
            } else {
                return false
            }
        }
       
        }
            listeEvenementTri = listeEvenementTriTemp
        } else {
            listeEvenementTri = evenementTab
        }
        return listeEvenementTri
    }
}

struct MapRechercheView_Previews: PreviewProvider {
    static var previews: some View {
        MapRechercheView(evenementTab: DataModel.shared.evenementTab, profilUser: DataModel.shared.profilUser, profilTab: DataModel.shared.profilTab, filtreVariable: DataModel.shared.filtreVariable)
    }
}



struct TypeDeLieux: Identifiable {
    let id = UUID()
    let nom: String
    let latitude: Double
    let longitude: Double
    let etiquette: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


