//
//  ShowSVGViewController.swift
//  Mask with SVG
//
//  Created by Nurbolat Yerdikul on 10/18/16.
//  Copyright © 2016 Nurbolat Yerdikul. All rights reserved.
//

import UIKit

class ShowSVGViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var openFilePath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSVGFile()
    }

    func loadSVGFile() {
        //    [web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
//        pathForResource:@"test" ofType:@"html"]isDirectory:NO]]];
        
        webView.loadRequest(URLRequest(url: openFilePath))

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
