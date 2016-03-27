//
//  ViewController.swift
//  DymicTableViewCell
//
//  Created by burt on 2016. 3. 3..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var imageList : [String]!
    var nameList : [String]!
    var urlList : [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameList = [
            "Buckingham Place",
            "The Eiffel Tower",
            "The Grand Cayon",
            "Winsor Castle",
            "Empire State Building"
        ]
        
        urlList = [
            "http://en.wikipedia.org/wiki/Buckingham_Palce",
            "http://en.wikipedia.org/wiki/Eiffel_Tower",
            "http://en.wikipedia.org/wiki/Grand_Canyon",
            "http://en.wikipedia.org/wiki/Windsor_Castle",
            "http://en.wikipedia.org/wiki/Empire_State_Building"
        ]
        
        imageList = [
            "buckingham_palace.jpg",
            "eiffel_tower.jpg",
            "grand_canyon.jpg",
            "windsor_castle.jpg",
            "empire_state_building.jpg"
        ]
        
        // 테이블뷰셀을 동적크기를 갖도록 만든다.
        // 이미지의 크기에 따라 셀의 높이가 결정된다.
        tableView.estimatedRowHeight = 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("DymicTableViewCell", forIndexPath: indexPath) as! DymicTableViewCell
        
        let row = indexPath.row
        cell.tLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        cell.tLabel.text = nameList[row]
        cell.tImageView.image = UIImage(named: imageList[row])
        return cell
    }

}

