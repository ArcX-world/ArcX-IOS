//
// Created by LLL on 2024/2/22.
//

import Foundation
import KeychainAccess

class AccessToken: Codable {

    let accessToken: String
    let expireDate: Date
    let refreshToken: String
    let userId: Int

    static var current: AccessToken? = defaultToken() {
        didSet { saveToken() }
    }

    static var isActive: Bool {
        if let token = current {
            return Date().timeIntervalSince1970 < token.expireDate.timeIntervalSince1970
        }
        return false
    }

    private static let keychain: Keychain = Keychain(service: Bundle.main.bundleIdentifier!)
            .accessibility(.afterFirstUnlock)
            .synchronizable(false)


    init(accessToken: String, expireDate: Date, refreshToken: String, userId: Int) {
        self.accessToken = accessToken
        self.expireDate = expireDate
        self.refreshToken = refreshToken
        self.userId = userId
    }


    // MARK: - Public

    func refreshAccessToken(completion: @escaping (Result<AccessToken, Error>) -> Void) {
        loginProvider.request(.refreshToken(token: refreshToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let accessToken = try response.map(String.self, atKeyPath: "serverMsg.aesTkn")
                    let refreshToken = try response.map(String.self, atKeyPath: "serverMsg.refTkn")
                    let expire = try response.map(Double.self, atKeyPath: "serverMsg.aesOt")
                    let expireData = Date(timeIntervalSince1970: expire / 1000)
                    AccessToken.current = AccessToken(accessToken: accessToken, expireDate: expireData, refreshToken: refreshToken, userId: self.userId)
                    completion(.success(AccessToken.current!))
                } catch {
                    AccessToken.current = nil
                    completion(.failure(error))
                }
                break
            case .failure(let error):
                AccessToken.current = nil
                completion(.failure(error))
                break
            }
        }
    }

    // MARK: - Private

    private class func defaultToken() -> AccessToken? {
        do {
            let data = try keychain.getData("TOKEN")
            return AccessToken.from(json: data)
        } catch {
            logger.error(error)
        }
        return nil
    }

    private class func saveToken() {
        do {
            if let jsonObject = current?.toJSONObject() {
                let data = try JSONSerialization.data(withJSONObject: jsonObject)
                try keychain.set(data, key: "TOKEN")
            } else {
                try keychain.remove("TOKEN")
            }
        } catch {
            logger.error(error)
        }
    }




}
