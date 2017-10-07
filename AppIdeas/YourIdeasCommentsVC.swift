//
//  YourIdeasCommentsVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 9/24/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class YourIdeasCommentsVC: UIViewController {
    
    var ideaID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension YourIdeasCommentsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension YourIdeasCommentsVC: UITableViewDelegate {
    
}
