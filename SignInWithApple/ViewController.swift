//
//  ViewController.swift
//  SignInWithApple
//
//  Created by shiga on 20/11/19.
//  Copyright © 2019 Shigas. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    let button = ASAuthorizationAppleIDButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        button.addTarget(self, action: #selector(handleAppleIDAuthorization), for: .touchUpInside)
        button.frame.size.width = 300
        button.frame.size.height = 60
        button.center = self.view.center
        //CGRect(origin:self.view.center, size: CGSize(width: 300, height: 60))
        
        self.view.addSubview(button)
    }

    @objc func handleAppleIDAuthorization() {
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self 
        controller.performRequests()
        
        
    }

}

extension ViewController: ASAuthorizationControllerDelegate{
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
           
            let userId = credentials.user
            print("User Identifier: ", userId)
            
            if let fullName = credentials.fullName {
                print(fullName)
            }
            
            if let emailId = credentials.email {
                print(emailId)
            }
            break
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple ID Authorization failed. ", error.localizedDescription)
    }
}


extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
