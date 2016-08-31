# Zero If Statement experiment

Woke up this morning with a desire to see if I can do away with if statements altogether.
I decided to implement a quick and dirty login system in swift that just checks to see
whether the supplied password matches the stored one and returns a response accordingly.

The implementation boiled down to these two differences..

```
let potentialActions: [Bool:Action] = [
    true : LoggedInAction(cred: cred),
    false : InvalidPasswordAction()
]
let auth = UserAuthentication(username: username, password: password, credentials: creds)
let action = potentialActions[auth.passwordMatches()]!
print(action.response())
```

and 

```
let auth = UserAuthentication(username: username, password: password, credentials: creds)

var action: Action
if(auth.passwordMatches()) {
    action = LoggedInAction(cred: cred)
} else {
    action = InvalidPasswordAction()
}

print(action.response())
```
