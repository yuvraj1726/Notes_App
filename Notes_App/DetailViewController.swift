//
//  DetailViewController.swift
//  Notes_App
//
//  Created by Yuvaraja Krishnamourthy Bhavani on 02/07/19.
//  Copyright © 2019 Yuvaraja Krishnamourthy Bhavani. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class DetailViewController: UIViewController {

   
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    var text: String = ""
    var titleText: String = ""
    var masterView:ViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
        textField.text = titleText
        self.navigationItem.largeTitleDisplayMode = .never
    
    }
    
    func setText(t:String,t1:String)
    {
        text = t
        titleText = t1
        if isViewLoaded{
            textView.text = text
            textField.text = titleText
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        masterView.newRowText = textView.text!
        masterView.newRowText1 = textField.text!
        textView.resignFirstResponder()
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
