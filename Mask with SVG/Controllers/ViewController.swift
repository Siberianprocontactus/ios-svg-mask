//
//  ViewController.swift
//  Mask with SVG
//
//  Created by Nurbolat Yerdikul on 10/18/16.
//  Copyright © 2016 Nurbolat Yerdikul. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices
import SVGgh

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var imageViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var svgDocumentView: SVGDocumentView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        svgDocumentView.backgroundColor = UIColor.clear
        if let imageURL = URL(string: kImageURLString) {
            imageView.sd_setImage(with: imageURL)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showSVG()
    }

    func showSVG() {
        if svgDocumentView.renderer == nil {
            svgDocumentView.renderer = SVGRenderer(string: generateSVGString(view: svgDocumentView, imageTagString: nil))
        }
    }
    
    func generateSVGString(view: UIView, imageTagString: String?) -> String {
        let svgString = getSVGFileString()
        let imageTag = imageTagString == nil ? "" : imageTagString
        let width = svgDocumentView.frame.width
        let height = svgDocumentView.frame.height
        let result = String(format: svgString!, width, height, width, height, imageTag!, width, height, width, height, Int(round(width / 2)), Int(round(height / 2)))
        print(result)
        return result
    }
    
    func getSVGFileString() -> String? {
        let svgFilePath = Bundle.main.path(forResource: kSVGFileName, ofType: "svg")!
        if let svgString = try? String(contentsOfFile: svgFilePath, encoding: String.Encoding.utf8) {
            return svgString
        }
        return nil
    }

    
    // MARK: - Action
    
    private var trayOriginalCenter: CGPoint!

    @IBAction func didPanGestrure(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            trayOriginalCenter = CGPoint(x: imageViewCenterX.constant, y: imageViewCenterY.constant)
        } else if sender.state == UIGestureRecognizerState.changed {
            imageViewCenterX.constant = trayOriginalCenter.x + translation.x
            imageViewCenterY.constant = trayOriginalCenter.y + translation.y
            imageView.layoutIfNeeded()
        }
    }
    
    var svgFilePath: URL!
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if let filePath = generateSVGFileAndSave() {
            svgFilePath = filePath
            performSegue(withIdentifier: kShowSVGViewController, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case kShowSVGViewController:
            prepare(showSVGViewControllerSegue: segue, sender: sender)
        default:
            break
        }
    }
    
    func prepare(showSVGViewControllerSegue: UIStoryboardSegue, sender: Any?) {
        let showSVGViewController = showSVGViewControllerSegue.destination as! ShowSVGViewController
        showSVGViewController.openFilePath = svgFilePath
    }
    
    func generateSVGFileAndSave() -> URL? {
        let imageTag = String(format: "<image xlink:href=\"%@\" x=\"%f\" y=\"%f\" height=\"%fpx\" width=\"%fpx\"/>", kImageURLString, imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.height, imageView.frame.size.width)

        let svgFinaleGenerated = generateSVGString(view: svgDocumentView, imageTagString: imageTag)
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(kExportFileName)
            do {
                try svgFinaleGenerated.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                return path
            }
            catch {
                let alertController = UIAlertController(title: NSLocalizedString("Что-то пошло не так...", comment: ""), message: NSLocalizedString("Ошибка при записи SVG файла", comment: ""), preferredStyle: .actionSheet)
                present(alertController, animated: true) {
                }
            }
        }
        return nil
    }
}
