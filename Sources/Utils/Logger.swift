//
//  Logger.swift
//  MadridInGameiOSModule
//
//  Created by Carlos Diaz Moreno on 22/10/25.
//

import Foundation
import OSLog

final class Logger {
    static let shared = Logger()

    private let logger: OSLog
    var isEnabled: Bool = true

    private init(subsystem: String = Bundle.podBundle?.description ?? "MadridInGame", category: String = "general") {
        self.logger = OSLog(subsystem: subsystem, category: category)
    }

    func log(_ message: @autoclosure () -> String,
             type: OSLogType = .default,
             functionName: String = #function,
             fileName: String = #file,
             lineNumber: Int = #line) {
        guard isEnabled else { return }

        let file = (fileName as NSString).lastPathComponent
        os_log("[%{public}@:%{public}d - %{public}@] %{public}@",
               log: logger,
               type: type,
               file,
               lineNumber,
               functionName,
               message())
    }

    func log(_ error: @autoclosure () -> Error,
               functionName: String = #function,
               fileName: String = #file,
               lineNumber: Int = #line) {
        log(error().localizedDescription, type: .error, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
}
