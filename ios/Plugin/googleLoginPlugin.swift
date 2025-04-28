
import Foundation
import Capacitor
import GoogleSignIn


@objc(googleLoginPlugin)
public class googleLoginPlugin: CAPPlugin {
  
  @objc func googleLogin(_ call: CAPPluginCall) {
    
    guard let googleClientId = call.getString("googleClientId") else {
      call.reject("googleClientId not provided")
      return
    }
    
    guard let presentingVc = self.bridge?.viewController else {
      call.reject("No presenting view controller")
      return
    }
    
    let clientID = googleClientId
    let configuration = GIDConfiguration(clientID: clientID)
    
    Task {
        do {
            try await GIDSignIn.sharedInstance.signIn(with: configuration, presenting: presentingVc)

            guard let user = GIDSignIn.sharedInstance.currentUser else {
                call.reject("No user signed in")
                return
            }

            guard let idToken = user.authentication.idToken else {
                call.reject("No identity token")
                return
            }

            let email = user.profile?.email ?? ""

            call.resolve([
                "identityToken": idToken,
                "email": email
            ])
        } catch {
            call.reject(error.localizedDescription)
        }
    }
    
  }
  
  
  
  
}
