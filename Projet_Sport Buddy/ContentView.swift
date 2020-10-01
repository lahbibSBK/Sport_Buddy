//
//  ContentView.swift
//  Projet_Sport Buddy
//
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            MapRechercheView(evenementTab: DataModel.shared.evenementTab, profilUser: DataModel.shared.profilUser, profilTab: DataModel.shared.profilTab, filtreVariable: DataModel.shared.filtreVariable)
                .tabItem{
                    Image(systemName: "map")
                    Text("carte")
                }
            MessageView(profilUser: DataModel.shared.profilUser, messageTab: DataModel.shared.messageTab)
                .tabItem{
                    Image(systemName: "message")
                    Text("message")
                }
            ProfileView(profilUser: DataModel.shared.profilUser, evenementTab: DataModel.shared.evenementTab, profilTab: DataModel.shared.profilTab)
                .tabItem{
                    Image(systemName: "person")
                    Text("profile")
                }
            MesEvenementsView(profilUser: DataModel.shared.profilUser ,evenementTab: DataModel.shared.evenementTab, profilTab: DataModel.shared.profilTab, filtreVariable: DataModel.shared.filtreVariable)
                .tabItem{
                    Image(systemName: "calendar")
                    Text("mes évènements")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Création d'une Structure Lieu
struct Lieu: Identifiable {
    var id = UUID()
    let nom: String
    var latitude: Double
    var longitude: Double
    
}
//Création d'une Structure Sport Préférés
struct SportPrefere: Identifiable, Equatable {
    let id = UUID()
    var sport: ListeSport
    var niveau: Int
}
//Création d'une Structure Profil
struct Profil: Identifiable, Equatable {
    let id = UUID()
    var pseudo: String
    var avatar: String
    var nom: String
    var prenom: String
    var age: Int
    var sexe : String
    var bio: String
    var lieu: String
    var sportsPreferes: [SportPrefere] // [[« sport », niveau],[,],….] => structure
}
//Création d'une Structure Evenement
struct Evenement: Identifiable {
    
    let id = UUID()
    let organisateur: Profil
    let sport: ListeSport
    let niveau: Int
    var dateEtHeure: Date
    var description: String = ""
    var lieu: Lieu
    var participantMax: Int
    var participantsInscrits: [Profil]
    var participantsInscritsListeDAttente: [Profil]
    
    
    //Après l’évènement
    var evaluation: [Evaluation] //[nbr étoile, texte, participant, evenementID]
}


//Création d'une structure Evaluations
struct Evaluation: Identifiable {
    let id = UUID()
    let nombreEtoile: Int
    let texte: String
    let participant: Profil
}
//Création d'une Structure Message
struct Message: Identifiable {
    let id = UUID()
    var expediteur: Profil
    var destinataire: Profil
    var sujet: String
    var dateEtHeure: Date
}


//Création d'une structure Filtre
struct Filtre {
    var sport: ListeSport?
    var date: Date?
    var niveau: Int?
    var placeLibre: Bool?
    var lieu: Lieu?
    var rayon: Int?
    //var organisateur: Profil
}
//Création d'une structure Liste sport
struct ListeSport: Equatable {
    var sportIcone: String
    var nomSport: String
}

class DataModel {
    static let shared: DataModel = DataModel()
    var filtreVariable: Filtre //@Published
    
    init() {
        self.filtreVariable = Filtre(sport: ListeSport(sportIcone: "", nomSport: "PingPong"), date: Date(), niveau: 1, placeLibre: true, lieu: Lieu(nom: "Parc BirHakim", latitude: 45.752592, longitude: 4.855175), rayon: 5)
        CreationLieuxFake()
        CreationListeSport()
        CreationProfilFake()
        CreationEvenementFake()
        CreationMessageFake()
    }
    //-------------------------------------------
    var isRecherche: Bool = true
    //-------------------------------------------
    //Création Struture, constante et variable
    //Constante avec la liste des sports
    var listeSports: [ListeSport] = []
    
    var lieuTab: [Lieu] = []
    private func CreationLieuxFake() {
        //Fonction qui crée des coordonnées sur lyon au hasard limite sud, nord, est , ouest
        lieuTab = [
            Lieu(nom: "Parc Blandan", latitude: 45.74449, longitude: 4.853691),
            Lieu(nom: "Parc de la tête d'Or", latitude:  45.778561, longitude: 4.853691),
            Lieu(nom: "Parc de Parilly", latitude: 45.718069, longitude: 4.902958),
            Lieu(nom: "Stade de Gerland", latitude: 45.722862, longitude: 4.823221),
            Lieu(nom: "Parc George Bazin", latitude: 45.752248, longitude: 4.881922),
            Lieu(nom: "Parc Chambovet", latitude: 45.748116, longitude: 4.894968),
            Lieu(nom: "Parc des Minguettes", latitude: 45.722862, longitude: 4.823221),
            Lieu(nom: "Parc Sisley", latitude: 45.751964, longitude: 4.867159),
            Lieu(nom: "Parc Jacob Kaplan", latitude: 45.752188, longitude: 4.857246),
            Lieu(nom: "Parc BirHakim", latitude: 45.752592, longitude: 4.855175),
            Lieu(nom: "Terrain de sports du Colombier", latitude: 45.746326, longitude: 4.84435),
            Lieu(nom: "Gymnase Louis Chanfray", latitude: 45.7440828, longitude: 4.8172566),
            Lieu(nom: "Gymnase Clemenceau", latitude: 45.7481593, longitude: 4.8385669),
            Lieu(nom: "Gymnase Genety", latitude: 45.7719061, longitude: 4.8195299),
            Lieu(nom: "Gymnase de la Martinière", latitude: 45.7845902, longitude: 4.7949621),
            Lieu(nom: "Gymnase Ferber", latitude: 45.7735221, longitude: 4.8001322),
            Lieu(nom: "Gymnase Maurice Scève", latitude: 45.7789765, longitude: 4.8372134),
            Lieu(nom: "Parc des Hauteurs", latitude: 45.762719, longitude: 4.8229151),
            Lieu(nom: "Parc de la Cerisaie", latitude: 45.7751, longitude: 4.8271)
        ]
    }
    
    //Constate avec la liste des niveaux
    let niveau: [Int] = [1, 2, 3]
    
    //Constante avec la liste des sexes
    let sexe: [String] = ["🚺", "🚹", "👽"]
    
    //Constante avec les évaluations
    let evaluationTab: [String] = ["Best Buddy", "Je recommande", "à la prochaine", "épique", "dream team", "je vais m'entrainer pour la prochaine fois", "Buddy d'Or", "Légend...wait for it...dary", "Champion du monde", "bof", "Amateur", "Bad very bad", "la lose", "Pas de bol"]
    
    
    
    //Création des fakes
    //Création des Profils fakes
    var profilUser: Profil = Profil(pseudo: "Thérèse69", avatar: "🧑🏽‍🎤", nom: "De Mousou", prenom: "Thérèse", age: Int.random(in: 18...35), sexe: "🚺", bio: "Je ne vous jete pas la pierre, Pierre!", lieu: "Lyon", sportsPreferes: [SportPrefere(sport: ListeSport(sportIcone: "⚽️", nomSport: "Football"), niveau: 2), SportPrefere(sport: ListeSport(sportIcone: "🏀", nomSport: "Basketball"), niveau: 1), SportPrefere(sport: ListeSport(sportIcone:  "🎾", nomSport: "Tennis"), niveau: 3), SportPrefere(sport: ListeSport(sportIcone: "🏊🏽‍♂️", nomSport: "Natation"), niveau: 1), SportPrefere(sport: ListeSport(sportIcone: "🚴🏽‍", nomSport: "Cyclisme"), niveau: 2), SportPrefere(sport: ListeSport(sportIcone: "🏃🏽", nomSport: "Course à Pieds"), niveau: 3)])
    
    
    //déclaration du tableau qui va contenir tout les pofils
    var profilTab: [Profil] = []
    
    private func CreationProfilFake() {
        
        
        //tabeau de faux pseudo
        let pseudoTab: [String] = ["MessiBarca4ever", "JeanClaudeDuss", "ZizouCoup2Boule", "ThérèseduTurFu", "JVCD", "PikaPika", "XenaLaHess", "AmélieMauresmo", "Cacatoes", "André3000"]
        //tableau de faux prénom
        let nomTab: [String] = ["Messi", "Duss", "Zidane", "Marie", "Van Damn", "Pikachou", "Guerrière", "Mauresmo", "Juan", "4000"]
        //tableau de faux prénom
        let prenomTab: [String] = ["Lionel", "Jean-Claude", "Zinedine", "Thérèse", "Jean-claude", "Chou", "Xena", "Amélie", "Carlos", "André"]
        //tableau de faux bio
        let bioTab: [String] = ["J'aime le sport", "schouss", "ça farte", "à fond la forme!!", "ça pète le feu", "vises le sommet", "never give up", "asics", "performance à tout prix", "think different", "push limit"]
        //tableau d'avatars
        let avatarTab: [String] = ["🤠", "🤡", "💩", "👻", "🤖", "😺", "👧🏼", "🧒🏽", "👩🏾", "👳🏽‍♂️", "🧕🏿", "👲🏽", "🧑🏽‍🎤"]
        
        //ajout du profil utilisateur dans le tableau utilisateur
        profilTab.append(profilUser)
        
        //Création de plusieurs profils
        for _ in 1...10 {
            var listeSportsTemp: [SportPrefere] = []
            for _ in 1...Int.random(in: 1...listeSports.count) {
                listeSportsTemp.append(SportPrefere(sport: listeSports.randomElement()!, niveau: niveau.randomElement()!))
            }
            
            
            let fakeProfil: Profil = Profil(pseudo: pseudoTab.randomElement()!, avatar: avatarTab.randomElement()!, nom: nomTab.randomElement()!, prenom: prenomTab.randomElement()!, age: Int.random(in: 18...35), sexe: sexe.randomElement()!, bio: bioTab.randomElement()!, lieu:"Lyon", sportsPreferes: listeSportsTemp)
            //rajoute le faux profil dans le tableau
            profilTab.append(fakeProfil)
        }
    }
    
    //Création des événements fakes
    //déclaration du tableau qui va contenir tout les pofils
    var evenementTab: [Evenement] = []
    
    private func CreationEvenementFake() {
        let descriptionTemp: String = """
On se donne rendez devant le terrain de basket n°1, soyez à l'heure,
Les équipes se feront au hasard.
J'apporte le ballon
il y a une fontaine à proximité
"""
        for sport in listeSports {
            for _ in 1...7 {
                var participantsInscritsTemp: [Profil] = []
                var participantsListeDAttenteTemp: [Profil] = []
                let participantMaxTemp = Int.random(in: 4...10)
                let participantInscrits = Int.random(in: 1...participantMaxTemp)
                var evaluationTemp: [Evaluation] = []
                
                //Choix de profils pour la liste des participants
                for _ in 1...participantInscrits {
                    participantsInscritsTemp.append( contentsOf: [profilTab.randomElement()!])
                    
                    //Si le nombre d'inscrits est inférieur au nombre de places
                    if participantMaxTemp == participantInscrits {
                        participantsListeDAttenteTemp.append(contentsOf: [profilTab.randomElement()!])
                    }
                    
                    //Création des évaluations fakes
                    for _ in 1...Int.random(in: 1...participantMaxTemp) {
                        let fakeEvaluation: Evaluation = Evaluation(nombreEtoile: Int.random(in: 1...5), texte: evaluationTab.randomElement()!, participant: participantsInscritsTemp.randomElement()!)
                        evaluationTemp.append(fakeEvaluation)
                    }
                }
                
                var lieu = lieuTab.randomElement()!
                lieu.latitude += randomGPS()
                lieu.longitude += randomGPS()
                
                let fakeEvenement: Evenement = Evenement(organisateur: profilTab.randomElement()!, sport: ListeSport(sportIcone: sport.sportIcone, nomSport: sport.nomSport), niveau: niveau.randomElement()!, dateEtHeure: generateRandomDate(daysBack: Int.random(in: 0...5))!, description: descriptionTemp, lieu: lieu, participantMax: participantMaxTemp, participantsInscrits: participantsInscritsTemp, participantsInscritsListeDAttente: participantsListeDAttenteTemp, evaluation: evaluationTemp)
                
                evenementTab.append(fakeEvenement)
            }
        }
    }
    
    //Création d'une date et d'une heure random
    private func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = (Bool.random() == true ? 1 : -1 ) * Int(day - 1)
        offsetComponents.hour = -1 * Int(hour)
        offsetComponents.minute = -1 * Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
    var messageTab: [Message] = []
    //Fonction qui crée des messages fake
    private func CreationMessageFake () {
        
        let bioTab: [String] = ["J'aime trop le sport, et vous ?", "Des volontaires pour mon volley, Samedi ?", "Je vous souhaite de passer un bon moment à tous !", "J'ai pas peur de suer !! Moi ! Invitez-moi !!", "Je veux faire une activitée, mais je sais pas quoi faire ! Des propositions ?", "vises le sommet, à tous les coups !", "Et si on se rencontrait ?, ce serait vachement cool", "Je propose un Badminton , qui veux venir ?", "La performance tout en s'amusant, c'est mon crédo ! ", "Cette appli est vraiment cool : de nouvelles rencontres, du sport, et du fun !!", "Je déteste la seconde place !!!"]
        for _ in 1...10 {
            let fakeMessage = Message(expediteur: profilTab.randomElement()!, destinataire: profilTab.randomElement()!, sujet: bioTab.randomElement()!, dateEtHeure: generateRandomDate(daysBack: 3)!)
            messageTab.append(fakeMessage)
        }
    }
    func CreationListeSport() {
        listeSports =
            [ListeSport(sportIcone: "⚽️", nomSport: "Football"), ListeSport(sportIcone: "🏀", nomSport: "Basketball"), ListeSport(sportIcone: "🏈", nomSport: "Rugby"), ListeSport(sportIcone: "🎾", nomSport: "Tennis"), ListeSport(sportIcone: "🏐", nomSport: "Volley"), ListeSport(sportIcone: "🥏", nomSport: "Frisbee"), ListeSport(sportIcone: "🏓", nomSport: "PingPong"), ListeSport(sportIcone: "🏸", nomSport: "Badminton"), ListeSport(sportIcone: "🏒", nomSport: "Hockey"), ListeSport(sportIcone: "🥊", nomSport: "Boxe"), ListeSport(sportIcone: "🧘🏽‍", nomSport: "Yoga"), ListeSport(sportIcone: "🏊🏽‍♂️", nomSport: "Natation"), ListeSport(sportIcone: "🚴🏽‍", nomSport: "Cyclisme"), ListeSport(sportIcone: "🧗🏾‍♀️", nomSport: "Escalade"), ListeSport(sportIcone: "🥋", nomSport: "Judo"), ListeSport(sportIcone: "🏃🏽", nomSport: "Course à Pieds")]
    }
}

func randomGPS() -> Double {
    return (Bool.random() == true ? 1 : -1 ) * 0.0005 * Double(Int.random(in: 1...10))
}
