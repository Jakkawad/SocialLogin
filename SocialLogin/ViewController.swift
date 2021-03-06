//
//  ViewController.swift
//  SocialLogin
//
//  Created by Jakkawad Chaiplee on 7/10/2560 BE.
//  Copyright © 2560 Jakkawad Chaiplee. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        //if email can't print in graphrequest
        loginButton.readPermissions = ["email", "public_profile"]
        
        //add custom fb login button
        let customFBButton = UIButton(type: .system)
        customFBButton.backgroundColor = .blue
        customFBButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        customFBButton.setTitle("Cutom FB Login", for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(customFBButton)
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
        //add custom google login button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        //custom
        let customGoogleButton = UIButton(type: .system)
        customGoogleButton.frame = CGRect(x: 16, y: 116 + 66 + 66, width: view.frame.width - 32, height: 50)
        customGoogleButton.backgroundColor = .orange
        customGoogleButton.setTitle("Custom Google Sign In", for: .normal)
        customGoogleButton.addTarget(self, action: #selector(handleCustomGoogleSignIn), for: .touchUpInside)
        view.addSubview(customGoogleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func handleCustomGoogleSignIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed", err ?? "")
                return
            }
            self.showEmailAddress()
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        self.showEmailAddress()
        
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("Something went wrong with our FB User: ", error ?? "")
                return
            }
            print("Successfully logged in with our user: ", user ?? "")
        }
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if err != nil {
                print("Failed to start graph requestt:", err ?? "")
                return
            }
            print(result ?? "")
            
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

