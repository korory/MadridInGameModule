//
//  MockInformation.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

let mockIndividualReservation =
    ReservationQRModel(dateSelected: "19/12/2014", hoursSelected: ["16:00", "17:00", "18:00"], consoleSelected: "PC", isReservationValid: false, isDNICorrect: false)

let imageDefaultProfile = UIImage(named: "imageDefaultProfile") ?? UIImage()

/*let mockAllPlayersInTeam = [
    PlayerModel(name: "Player1", image: imageDefaultProfile, roleAssign: "Manager"),
    PlayerModel(name: "Player2", image: imageDefaultProfile, roleAssign: "Player"),
    PlayerModel(name: "Player3", image: imageDefaultProfile, roleAssign: "Trainer"),
    PlayerModel(name: "Player4", image: imageDefaultProfile, roleAssign: "Trainer"),
    PlayerModel(name: "Player5", image: imageDefaultProfile, roleAssign: "Player"),
    PlayerModel(name: "Player6", image: imageDefaultProfile, roleAssign: "Player"),
    PlayerModel(name: "Player7", image: imageDefaultProfile, roleAssign: "Player"),
    PlayerModel(name: "Player8", image: imageDefaultProfile, roleAssign: "Player"),
    PlayerModel(name: "Player9", image: imageDefaultProfile, roleAssign: "Player"),
    PlayerModel(name: "Player10", image: imageDefaultProfile, roleAssign: "Player")
]*/

/*let mockAllTeams = [
    mockTeamPapaFrita,
    mockTeamSamsung,
    mockTeamCoffee,
    mockTeamVisa
]*/

/*let mockOnePlayer = PlayerModel(name: "Player1", image: imageDefaultProfile, roleAssign: "Manager")

let mockTeamPapaFrita = TeamModel(name: "Team Papa Frita", descriptionText: "description Text", discordLink: "", image: imageDefaultProfile, allRolesAvailable: ["Manager", "Trainer", "Player"], allPlayersAssigned: Array(mockAllPlayersInTeam.prefix(5)))

let mockTeamSamsung = TeamModel(name: "Team Samsung", descriptionText: "description Textdescription Text", discordLink: "", image: imageDefaultProfile, allRolesAvailable: ["Manager", "Trainer", "Player"], allPlayersAssigned: Array(mockAllPlayersInTeam.prefix(7)))

let mockTeamCoffee = TeamModel(name: "Team Coffee", descriptionText: "", discordLink: "", image: imageDefaultProfile, allRolesAvailable: ["Manager", "Trainer", "Player"], allPlayersAssigned: Array(mockAllPlayersInTeam.prefix(4)))

let mockTeamVisa = TeamModel(name: "Team Visa", descriptionText: "description Text", discordLink: "", image: imageDefaultProfile, allRolesAvailable: ["Manager", "Trainer", "Player"], allPlayersAssigned: Array(mockAllPlayersInTeam.prefix(4)))

// Mock de datos para la lista de reservas
let mockTeamReservationCellViewModel = [
    TeamReservationModel(
        trainingLocation: .eSportsCenter,
        dateSelected: "19/12/1996",
        hoursSelected: ["18:00", "19:00"],
        playersAsigned: Array(mockAllPlayersInTeam.prefix(2)),
        descriptionText: "Este es un texto de prueba para el primer equipo. Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto.",
        consoleSelected: "PC"
    ),
    TeamReservationModel(
        trainingLocation: .eSportsCenter,
        dateSelected: "20/12/1996",
        hoursSelected: ["17:00", "18:30"],
        playersAsigned: mockAllPlayersInTeam + mockAllPlayersInTeam,
        descriptionText: "Este es un texto de prueba para el segundo equipo. Se ha usado el Lorem Ipsum como texto de relleno por siglos.",
        consoleSelected: "Xbox"
    ),
    TeamReservationModel(
        trainingLocation: .virtual,
        dateSelected: "21/12/1996",
        hoursSelected: ["19:00"],
        playersAsigned: Array(mockAllPlayersInTeam.prefix(5)),
        descriptionText: "Tercer equipo, texto de prueba para mostrar las reservas del equipo de gimnasio.",
        consoleSelected: "PlayStation"
    )
]

// Mock de datos para la lista de reservas
let mockIndividualReservationCellViewModel = [
    IndividualReservationModel(
        trainingLocation: .eSportsCenter,
        teamAssign: mockTeamPapaFrita,
        dateSelected: "19/12/1996",
        hoursSelected: "18:00"
    ),
    IndividualReservationModel(
        trainingLocation: .virtual,
        teamAssign: mockTeamSamsung,
        dateSelected: "19/12/1996",
        hoursSelected: "19:00"
    ),
    IndividualReservationModel(
        trainingLocation: .eSportsCenter,
        teamAssign: mockTeamCoffee,
        dateSelected: "19/12/1996",
        hoursSelected: "20:00"
    ),
]*/

let mockAllNews = [
    NewsModel(title: "Nuevo club de E-Sports", description: "Al contrario del pensamiento popular, el texto de Lorem Ipsum no es simplemente texto aleatorio. Tiene sus raices en una pieza cl´sica de la literatura del Latin, que data del año 45 antes de Cristo, haciendo que este adquiera mas de 2000 años de antiguedad. Richard McClintock, un profesor de Latin de la Universidad de Hampden-Sydney en Virginia, encontró una de las palabras más oscuras de la lengua del latín, , en un pasaje de Lorem Ipsum, y al seguir leyendo distintos textos del latín, descubrió la fuente indudable. Lorem Ipsum viene de las secciones 1.10.32 y 1.10.33 de de Finnibus Bonorum et Malorum (Los Extremos del Bien y El Mal) por Cicero, escrito en el año 45 antes de Cristo. Este libro es un tratado de teoría de éticas, muy popular durante el Renacimiento. La primera linea del Lorem Ipsum, Lorem ipsum dolor sit amet.., viene de una linea en la sección 1.10.32", image: UIImage(), imageText: ""),
    NewsModel(title: "Segundo Nuevo club de E-Sports", description: "Al contrario del pensamiento popular, el texto de Lorem Ipsum no es simplemente texto aleatorio. La primera linea del Lorem Ipsum, Lorem ipsum dolor sit amet.., viene de una linea en la sección 1.10.32", image: UIImage(), imageText: ""),
    NewsModel(title: "Otro club de E-Sports", description: "Al contrario del pensamiento popular, el texto de Lorem Ipsum no es simplemente texto aleatorio. Tiene sus raices en una pieza cl´sica de la literatura del Latin, que data del año 45 antes de Cristo, haciendo que este adquiera mas de 2000 añticas, muy popular durante el Renacimiento. La primera linea del Lorem Ipsum, Lorem ipsum dolor sit amet.., viene de una linea en la sección 1.10.32", image: UIImage(), imageText: ""),
    NewsModel(title: "No vea tu otro club de E-Sports", description: "Al contrario del pensamiento popular, el texto de Lorem Ipsum no es simplemente texto aleatorio. Tiene sus raices en una pieza cl´sica de la literatura del Latin, que data del año 45 antes de Cristo, haciendo que este adquiera mas de 2000 años de antiguedad. Richard McClintock, un profesor de Latin de la Universidad de Hampden-Sydney en Virginia, encontró una de las palabras más oscu de éticas, muy popular durante el Renacimiento. La primera linea del Lorem Ipsum, Lorem ipsum dolor sit amet.., viene de una linea en la sección 1.10.32", image: UIImage(), imageText: "")
]

let mockOneNewEmpty = NewsModel(title: "", description: "", image: imageDefaultProfile, imageText: "")

let mockCompetitions = CompetitionsModel(
    seasons: [
        SeasonsModel(
            year: "2024",
            mundialLeague: [
                LeagueModel(
                    title: "Liga Municipal",
                    seriesTitle: "Esports Series Madrid",
                    description: "Madrid in Game es la apuesta del Ayuntamiento de Madrid para elevar el talento amateur de los Esports con la creación de las competiciones: Esports Series Madrid . Constan de dos temporadas al año en las que podrás enfrentarte a los mejores jugadores en un entorno de juego seguro y óptimo.",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .fornite,
                            title: "Esports Series Madrid Fortnite",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "Madrid in Game, iniciativa del Ayuntamiento de Madrid, inicia el Split 2 de la segunda temporada de la Esports Series Madrid de Fortnite. Busca una pareja, compite, entrena en el Esports Center de Casa de Campo con tus amigos y llega a lo más alto en los clasificatorios de las ligas municipales para reinar en la capital.",
                                            details: "Se competirá mediante el formato Dúos, contará con cuatro clasificatorios en cada split, que sumarán puntos en una tabla clasificatoria. Apúntate a los distintos clasificatorios, llega a la fase final y consigue puntos para llegar a la Gran Final.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "Podréis contactar con Madrid in Game a través del Canal de Discord de la Esports Series Madrid o a través del siguiente correo electrónico: esportscenter@madridingame.es Además, dentro del servidor de Discord podréis también hablar con cydoniaknight, el administrador de la competición."),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        ),
                        CompetitionsDetailModel(
                            competitionType: .valorant,
                            title: "Esports Series Madrid Fortnite",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        ),
                        CompetitionsDetailModel(
                            competitionType: .rocketLeague,
                            title: "Esports Series Madrid Rocket League",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                ),
                LeagueModel(
                    title: "Liga Municipal Junior",
                    seriesTitle: "Esports Series Madrid",
                    description: "El equivalente de la Esports Series Madrid para colegios e institutos de la ciudad. La ESM Junior Esports es tu puerta de entrada para que puedas participar con tu centro educativo en la liga municipal junior de League of Legends y Rocket League.",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .valorant,
                            title: "Esports Series Madrid Valorant",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                ),
                LeagueModel(
                    title: "Circuito Tormenta",
                    seriesTitle: "Esports Series Madrid",
                    description: "Las Esports Series Madrid de Madrid in Game serán parada oficial del Circuito de Tormenta. Contarán con las competiciones de League of Legends y Valorant, además de disputarse una gran Final presencial. Los torneos otorgaran puntos para el ranking general del Circuito de Tormenta del Split correspondiente.",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .valorant,
                            title: "Esports Series Madrid Valorant",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                ),
                LeagueModel(
                    title: "Otras competiciones",
                    seriesTitle: "Esports Series Madrid",
                    description: "",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .lol,
                            title: "Torneo 1vs1 League of Legends Cazacracks",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                )
            ]
        ),
        SeasonsModel(
            year: "2023",
            mundialLeague: [
                LeagueModel(
                    title: "Liga Municipal",
                    seriesTitle: "Esports Series Madrid",
                    description: "Madrid in Game es la apuesta del Ayuntamiento de Madrid para elevar el talento amateur de los Esports con la creación de las competiciones: Esports Series Madrid . Constan de dos temporadas al año en las que podrás enfrentarte a los mejores jugadores en un entorno de juego seguro y óptimo.",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .fornite,
                            title: "Esports Series Madrid Fortnite",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "Madrid in Game, iniciativa del Ayuntamiento de Madrid, inicia el Split 2 de la segunda temporada de la Esports Series Madrid de Fortnite. Busca una pareja, compite, entrena en el Esports Center de Casa de Campo con tus amigos y llega a lo más alto en los clasificatorios de las ligas municipales para reinar en la capital.",
                                            details: "Se competirá mediante el formato Dúos, contará con cuatro clasificatorios en cada split, que sumarán puntos en una tabla clasificatoria. Apúntate a los distintos clasificatorios, llega a la fase final y consigue puntos para llegar a la Gran Final.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "Podréis contactar con Madrid in Game a través del Canal de Discord de la Esports Series Madrid o a través del siguiente correo electrónico: esportscenter@madridingame.es Además, dentro del servidor de Discord podréis también hablar con cydoniaknight, el administrador de la competición."),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                ),
                LeagueModel(
                    title: "Liga Municipal Junior",
                    seriesTitle: "Esports Series Madrid",
                    description: "El equivalente de la Esports Series Madrid para colegios e institutos de la ciudad. La ESM Junior Esports es tu puerta de entrada para que puedas participar con tu centro educativo en la liga municipal junior de League of Legends y Rocket League.",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .valorant,
                            title: "Esports Series Madrid Valorant",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                ),
                LeagueModel(
                    title: "Circuito Tormenta",
                    seriesTitle: "Esports Series Madrid",
                    description: "Las Esports Series Madrid de Madrid in Game serán parada oficial del Circuito de Tormenta. Contarán con las competiciones de League of Legends y Valorant, además de disputarse una gran Final presencial. Los torneos otorgaran puntos para el ranking general del Circuito de Tormenta del Split correspondiente.",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .valorant,
                            title: "Esports Series Madrid Valorant",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                ),
                LeagueModel(
                    title: "Otras competiciones",
                    seriesTitle: "Esports Series Madrid",
                    description: "",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .lol,
                            title: "Torneo 1vs1 League of Legends Cazacracks",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                )
            ]
        ),
        SeasonsModel(
            year: "2022",
            mundialLeague: [
                LeagueModel(
                    title: "Liga Municipal",
                    seriesTitle: "Esports Series Madrid",
                    description: "Madrid in Game es la apuesta del Ayuntamiento de Madrid para elevar el talento amateur de los Esports con la creación de las competiciones: Esports Series Madrid . Constan de dos temporadas al año en las que podrás enfrentarte a los mejores jugadores en un entorno de juego seguro y óptimo.",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .fornite,
                            title: "Esports Series Madrid Fortnite",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "Madrid in Game, iniciativa del Ayuntamiento de Madrid, inicia el Split 2 de la segunda temporada de la Esports Series Madrid de Fortnite. Busca una pareja, compite, entrena en el Esports Center de Casa de Campo con tus amigos y llega a lo más alto en los clasificatorios de las ligas municipales para reinar en la capital.",
                                            details: "Se competirá mediante el formato Dúos, contará con cuatro clasificatorios en cada split, que sumarán puntos en una tabla clasificatoria. Apúntate a los distintos clasificatorios, llega a la fase final y consigue puntos para llegar a la Gran Final.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "Podréis contactar con Madrid in Game a través del Canal de Discord de la Esports Series Madrid o a través del siguiente correo electrónico: esportscenter@madridingame.es Además, dentro del servidor de Discord podréis también hablar con cydoniaknight, el administrador de la competición."),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        ),
                        CompetitionsDetailModel(
                            competitionType: .rocketLeague,
                            title: "Esports Series Madrid Rocket League",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                ),
                LeagueModel(
                    title: "Liga Municipal Junior",
                    seriesTitle: "Esports Series Madrid",
                    description: "El equivalente de la Esports Series Madrid para colegios e institutos de la ciudad. La ESM Junior Esports es tu puerta de entrada para que puedas participar con tu centro educativo en la liga municipal junior de League of Legends y Rocket League.",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .valorant,
                            title: "Esports Series Madrid Valorant",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                ),
                LeagueModel(
                    title: "Circuito Tormenta",
                    seriesTitle: "Esports Series Madrid",
                    description: "Las Esports Series Madrid de Madrid in Game serán parada oficial del Circuito de Tormenta. Contarán con las competiciones de League of Legends y Valorant, además de disputarse una gran Final presencial. Los torneos otorgaran puntos para el ranking general del Circuito de Tormenta del Split correspondiente.",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .valorant,
                            title: "Esports Series Madrid Valorant",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                ),
                LeagueModel(
                    title: "Otras competiciones",
                    seriesTitle: "Esports Series Madrid",
                    description: "",
                    competitions: [
                        CompetitionsDetailModel(
                            competitionType: .lol,
                            title: "Torneo 1vs1 League of Legends Cazacracks",
                            allSplitsAvailable: [
                                SplitsModel(title: "Split de Otoño", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com"),
                                SplitsModel(title: "Split de Invierno", bannerImage: UIImage(), overviewDescription: "The biggest Valorant competition featuring the best teams worldwide.",
                                            details: "Teams compete in a multi-stage tournament with a final showdown in the Grand Finals.",
                                            rules: "Participants must adhere to Riot Games' competition rulebook.",
                                            contact: "valorant-support@example.com")
                            ]
                        )
                    ]
                )
            ]
        )
    ]
)
