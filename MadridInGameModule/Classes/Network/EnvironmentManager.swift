//
//  EnvironmentManager.swift
//  MadridInGameModule
//
//  Created by Arnau Rivas Rivas on 7/1/25.
//

import Foundation

public class EnvironmentManager {
    // MARK: - Enumeración de Entornos
    public enum EnvironmentConfig: String {
        case pre = "https://premig.randomkesports.com/cms"
        case pro = "https://webesports.madridingame.es/cms"
        
        public init?(environment: String) {
            switch environment.lowercased() {
            case "pre":
                self = .pre
            case "pro":
                self = .pro
            default:
                return nil
            }
        }
    }
    
    // MARK: - Propiedades
    public let currentEnvironment: EnvironmentConfig
    
    // Inicializador
    public init(environment: String) {
        if let config = EnvironmentConfig(environment: environment) {
            self.currentEnvironment = config
        } else {
            self.currentEnvironment = .pro
        }
    }
    
    // MARK: - Métodos Públicos
    public func getBaseURL() -> String {
        return currentEnvironment.rawValue
    }
}

