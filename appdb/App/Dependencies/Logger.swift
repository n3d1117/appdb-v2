//
//  Logger.swift
//  appdb
//
//  Created by ned on 10/02/23.
//

import OSLog

class Logger {
    private let logger = os.Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Log")
    
    func log(_ level: OSLogType = .info, _ message: String) {
        logger.log(level: level, "\(message)")
    }
}
