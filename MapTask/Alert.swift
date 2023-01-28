//
//  Alert.swift
//  MapTask
//
//  Created by Akari Cloud on 08.09.20.
//

import UIKit

extension UIViewController {
    
    func alertAddAddress(title: String, placeholder: String, complitionHandler: @escaping (String) -> Void ) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default) { action in
            let tfText = alertController.textFields?.first
            guard let text = tfText?.text else { return }
            complitionHandler(text)
        }
        
        alertController.addTextField { (tf) in
            tf.placeholder = placeholder
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .default) { _ in }
        alertController.addAction(alertOk)
        alertController.addAction(alertCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func alertError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertOk)
        present(alertController, animated: true, completion: nil)
    }
}
