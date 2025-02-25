//
//  EnvironmentManager.swift
//  MadridInGameModule
//
//  Created by Arnau Rivas Rivas on 7/1/25.
//

import Foundation

public class EnvironmentManager {
    // MARK: - Enumeración de Entornos
    public enum EnvironmentConfig {
        case pre
        case pro
        
        // Inicializador con Booleano
        public init?(isPro: Bool) {
            self = isPro ? .pro : .pre
        }
        
        // Método para obtener la URL del entorno
        public func getBaseURL() -> String {
            switch self {
            case .pre:
                return "https://premig.randomkesports.com/cms"
            case .pro:
                return "https://webesports.madridingame.es/cms"
            }
        }
        
        // Método para obtener el nombre del entorno (PRE / PRO)
        public func getEnvironmentName() -> String {
            switch self {
            case .pre:
                return "PRE"
            case .pro:
                return "PRO"
            }
        }
    }
    
    // MARK: - Claves de UserDefaults
    private static let environmentKey = "selectedEnvironment"
    
    // MARK: - Propiedades
    public let currentEnvironment: EnvironmentConfig
    
    // MARK: - Inicializador
    public init(isPro: Bool? = nil) {
        if let isPro = isPro {
            self.currentEnvironment = EnvironmentConfig(isPro: isPro)!
            EnvironmentManager.saveEnvironment(isPro)
        } else if let savedEnv = EnvironmentManager.loadEnvironment() {
            self.currentEnvironment = EnvironmentConfig(isPro: savedEnv) ?? .pro
        } else {
            self.currentEnvironment = .pro
            EnvironmentManager.saveEnvironment(true)
        }
    }
    
    // MARK: - Métodos Públicos
    public func getBaseURL() -> String {
        return currentEnvironment.getBaseURL()
    }
    
    public func getEnvironmentName() -> String {
        return currentEnvironment.getEnvironmentName()
    }
    
    // MARK: - Métodos Privados (Almacenamiento en UserDefaults)
    private static func saveEnvironment(_ isPro: Bool) {
        UserDefaults.standard.set(isPro, forKey: environmentKey)
    }
    
    private static func loadEnvironment() -> Bool? {
        return UserDefaults.standard.value(forKey: environmentKey) as? Bool
    }
}

//public class EnvironmentManager {
//    // MARK: - Enumeración de Entornos
//    public enum EnvironmentConfig: String {
//        case pre = "https://premig.randomkesports.com/cms"
//        case pro = "https://webesports.madridingame.es/cms"
//        
//        public init?(environment: String) {
//            switch environment.lowercased() {
//            case "pre":
//                self = .pre
//            case "pro":
//                self = .pro
//            default:
//                return nil
//            }
//        }
//        
//        // Método para obtener el nombre del environment (PRE / PRO)
//        public func getEnvironmentName() -> String {
//            switch self {
//            case .pre:
//                return "PRE"
//            case .pro:
//                return "PRO"
//            }
//        }
//    }
//    
//    // MARK: - Claves de UserDefaults
//    private static let environmentKey = "selectedEnvironment"
//    
//    // MARK: - Propiedades
//    public let currentEnvironment: EnvironmentConfig
//    
//    // MARK: - Inicializador
//    public init(environment: String? = nil) {
//        if let env = environment, let config = EnvironmentConfig(environment: env) {
//            self.currentEnvironment = config
//            EnvironmentManager.saveEnvironment(env)
//        } else if let savedEnv = EnvironmentManager.loadEnvironment(),
//                  let config = EnvironmentConfig(environment: savedEnv) {
//            self.currentEnvironment = config
//        } else {
//            self.currentEnvironment = .pro
//            EnvironmentManager.saveEnvironment("pro")
//        }
//    }
//    
//    // MARK: - Métodos Públicos
//    public func getBaseURL() -> String {
//        return currentEnvironment.rawValue
//    }
//    
//    public func getEnvironmentName() -> String {
//        return currentEnvironment.getEnvironmentName()
//    }
//    
//    // MARK: - Métodos Privados (Almacenamiento en UserDefaults)
//    private static func saveEnvironment(_ environment: String) {
//        UserDefaults.standard.set(environment, forKey: environmentKey)
//    }
//    
//    private static func loadEnvironment() -> String? {
//        return UserDefaults.standard.string(forKey: environmentKey)
//    }
//}

//public class EnvironmentManager {
//    // MARK: - Enumeración de Entornos
//    public enum EnvironmentConfig: String {
//        case pre = "https://premig.randomkesports.com/cms"
//        case pro = "https://webesports.madridingame.es/cms"
//        
//        public init?(environment: String) {
//            switch environment.lowercased() {
//            case "pre":
//                self = .pre
//            case "pro":
//                self = .pro
//            default:
//                return nil
//            }
//        }
//    }
//    
//    // MARK: - Propiedades
//    public let currentEnvironment: EnvironmentConfig
//    
//    // Inicializador
//    public init(environment: String) {
//        if let config = EnvironmentConfig(environment: environment) {
//            self.currentEnvironment = config
//        } else {
//            self.currentEnvironment = .pro
//        }
//    }
//    
//    // MARK: - Métodos Públicos
//    public func getBaseURL() -> String {
//        return currentEnvironment.rawValue
//    }
//}

