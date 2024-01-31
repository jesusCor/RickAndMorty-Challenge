//
//  BaseVC.swift
//  Rick and Morty Challenge
//
//  Created by Jesus Coronado on 26/01/2024.
//

import UIKit
import MBProgressHUD
import SwiftMessages


class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavBar setup.
        configureNavigationBar()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    // MARK: Styling.
    
    func configureNavigationBar() {
        // Set the navBar title size & color
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30.0),
            NSAttributedString.Key.foregroundColor: ColorsPalette.appBlue,
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.strokeColor: ColorsPalette.appYellow
        ]
        
        // Set navigation bar icons color to black
        navigationController?.navigationBar.tintColor = ColorsPalette.appBlue
    }
    
    
    // MARK: Alerts.

    func displayAlertWithMessage(message: String, title: String = "", customOkTitle: String? = nil, toShowCancel: Bool = false, customOkAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okActionLabel = customOkTitle ?? NSLocalizedString("OK", comment: "OK Alert confirmation")
        alert.addAction(UIAlertAction(title: okActionLabel, style: .cancel, handler: customOkAction))
        
        if (toShowCancel) {
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Alert confirmation"), style: .default, handler: nil))
        }
        
        self.present(alert, animated: true)
    }

    func displayAlertWithMessageAndPop(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Alert confirmation"), style: .default, handler: { (alertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    
    // MARK: Additional functions.
    
    func showProgressHUD() {
        DispatchQueue.main.async {
            if let vw = self.view{
                MBProgressHUD.showAdded(to: vw, animated: true)
            }
        }
    }
    
    func dismissProgressHUD(){
        DispatchQueue.main.async {
            if let vw = self.view{
                MBProgressHUD.hide(for: vw, animated: true)
            }
        }
    }
    
    func displayError(title: String, message: String) {
        // We wanna keep the error message on screen until the user manually dismisses it.
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        
        SwiftMessages.show(config: config) {
            let error = MessageView.viewFromNib(layout: .cardView)
            error.configureTheme(.error)
            error.configureContent(title: title, body: message)
            error.button?.setTitle("OK", for: .normal)
            error.buttonTapHandler = { _ in SwiftMessages.hide() }
            return error
        }
    }
    
}
