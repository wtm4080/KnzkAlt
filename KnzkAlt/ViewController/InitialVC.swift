//
//  InitialVC.swift
//  KnzkAlt
//
//  Created by mopopo on 2017/10/30.
//  Copyright © 2017年 AtCurio. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {
    @IBAction func loginAction(_ sender: Any) {
        self.performSegue(withIdentifier: "Login", sender: self)
    }
}
