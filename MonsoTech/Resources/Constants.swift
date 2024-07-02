//
//  Constants.swift
//  MonsoTech
//
//  Created by Ehtisham Badar on 19/06/2024.
//

import Foundation

class Constants {
    static let clientId = "668b03dc-0873-4043-97ea-7c20dd41fc9b"
    static let redirectURL = "https://monso.tech/auth"
    static let authorityURL = "https://login.microsoftonline.com/84842931-5c83-48d8-a112-c19574b78849"
    static let TENANT_NAME = "ehtishambadargmail.onmicrosoft.com"
    
    static let oid = getOid()
    
    static let kTenantName = "monsotech"
    static let kAuthorityHostName = "https://monsotech.b2clogin.com"
    static let kClientID = "668b03dc-0873-4043-97ea-7c20dd41fc9b"
    static let kRedirectUri = "msauth.com.monso.tech://auth"
    static let kPolicySignUpOrSignIn = "B2C_1_signup-and-in"
    
    static func getOid() -> String {
        if let user = UserDefaults.standard.getUser() {
            let oid = user.oid
            return oid
        }
        return ""
    }
    static func getToken() -> String {
        if let user = UserDefaults.standard.getUser() {
            let token = user.token
            return token
        }
        return ""
    }
}
