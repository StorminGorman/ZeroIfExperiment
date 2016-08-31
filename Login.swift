protocol Credential {
    func username() -> String
    func password() -> String
    func valid() -> Bool
}

class DefaultCredential : Credential {
    let _username: String
    let _password: String
    
    init(username: String, password: String) {
        self._username = username
        self._password = password
    }
    
    func username() -> String {
        return _username
    }
    
    func password() -> String {
        return _password
    }
    
    func valid() -> Bool {
        return true
    }
}

class InvalidCredential: Credential {
    func username() -> String {
        return "invalid"
    }
    func password() -> String {
        return "invalid"
    }
    func valid() -> Bool {
        return false
    }
}

protocol Credentials {
    func credentialFor(user username: String) -> Credential
}

class FakeCredentials : Credentials {
    let store: [String:Credential] = [
        "brian" : DefaultCredential(username: "brian", password: "somepass")
    ]
    
    let notFound:Credential = InvalidCredential()
    
    func credentialFor(user username: String) -> Credential {
        return store[username] ?? notFound
    }
}

protocol Action {
    func response() -> String
}

protocol Authenticate {
    func passwordMatches() -> Bool
}

class UserAuthentication : Authenticate {
    let username: String
    let password: String
    let credentials: Credentials
    
    init(username: String, password: String, credentials: Credentials) {
        self.username = username
        self.password = password
        self.credentials = credentials
    }
    
    func passwordMatches() -> Bool {
        let cred = credentials.credentialFor(user: username)
        return cred.valid() && cred.password() == password
    }
}

class LoggedInAction : Action {
    let cred: Credential
    init(cred: Credential) {
        self.cred = cred
    }
    func response() -> String {
        return "This is secret stuff for authentcated user \(cred.username())"
    }
}

class InvalidPasswordAction : Action {
    func response() -> String {
        return "Your password is invalid"
    }
}

class MainAction : Action {
    let action: Action
    
    init(username: String, password: String) {
        let creds = FakeCredentials()
        let cred = creds.credentialFor(user: username)
        
        let potentialActions: [Bool:Action] = [
            true : LoggedInAction(cred: cred),
            false : InvalidPasswordAction()
        ]
        
        let auth = UserAuthentication(username: username, password: password, credentials: creds)
        
        self.action = potentialActions[auth.passwordMatches()]!
    }
    
    func response() -> String {
        return action.response()
    }
}

class AltMainAction : Action {
    let action: Action
    
    init(username: String, password: String) {
        let creds = FakeCredentials()
        let cred = creds.credentialFor(user: username)
        
        
        let auth = UserAuthentication(username: username, password: password, credentials: creds)
        
        if(auth.passwordMatches()) {
            self.action = LoggedInAction(cred: cred)
        } else {
            self.action = InvalidPasswordAction()
        }
    }
    
    func response() -> String {
        return action.response()
    }
}

let username = "brian"
let password = "somepass"

let action = MainAction(username: username, password: password)

action.response()
