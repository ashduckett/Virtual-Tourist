//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Ash Duckett on 08/06/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import Foundation
import UIKit

class PhotoAlbumViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let newCollectionButton = UIBarButtonItem(title: "New Collection", style: .plain, target: self, action: #selector(newCollection))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        setToolbarItems([flexibleSpace, newCollectionButton, flexibleSpace], animated: true)
    }
    
    func newCollection() {
        
    }
}
