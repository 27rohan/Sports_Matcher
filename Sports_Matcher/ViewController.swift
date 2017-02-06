//
//  ViewController.swift
//  Sports_Matcher
//
//  Created by Rohan Manoj Thakkar on 2/4/17.
//  Copyright © 2017 Rohan Manoj Thakkar. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
/*
struct Person {
        static let name = "name"
        static let email = "email"
        static let zip_code = "zipcode"
        static let sport = "sport"
}
*/

class ViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate,MFMailComposeViewControllerDelegate {
    var ref: FIRDatabaseReference!
    
    var zipcodeText: String = ""
    
    var sport: String = ""
    
    var given_email:String = ""
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var zip_code: UITextField!
    
    fileprivate var _refHandle: FIRDatabaseHandle!
    

    @IBAction func submit(_ sender: Any) {
    submitAlert(message: "Are you sure all the information is correct and you want to submit now?", "Submit")
    }


    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = ["Football", "Baseball", "Soccer", "Volleyball", "Cricket", "Tennis", "Pool", "Throwball","Foosball","Swimming","Skating","Snowboarding"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        picker.dataSource = self
        picker.delegate = self
        sport = pickerData[0]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       func alert(message: String, _ submitLog:String){
        let alertController:UIAlertController = {
            return UIAlertController(title: "Submit", message: message, preferredStyle: UIAlertControllerStyle.alert)
        }()
        
        let okAlert:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alert: UIAlertAction!) -> Void in
            NSLog(submitLog)}
        alertController.addAction(okAlert)
        self.present(alertController, animated: true, completion: nil);
    }

    
    func submitSuccessful(){
        alert(message: "submit successful", "submitted!")
    }
    
        //submit alert
    
    func submitAlert(message: String, _ submitLog:String){
        self.storeInDB()
    }
    
    //basic email validater using regex
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func storeInDB() {
    
        var data = [String: String]()
        
        given_email = email.text! as String
        
        if !name.text!.isEmpty && given_email != "" && !zip_code.text!.isEmpty {
        if !self.isValidEmail(testStr: given_email) {
            let alertController = UIAlertController(title: "Invalid ID", message: "Please enter a valid email", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        else {
        
        data["email"] = given_email

        data["name"] = name.text! as String
    
        zipcodeText = zip_code.text! as String

        self.findMatches()
        
        ref.child(zipcodeText).child(sport).childByAutoId().setValue(data)
        
        self.submitSuccessful()
        

        self.name.text! = ""
        self.email.text! = ""
        self.zip_code.text! = ""
        }
        }
        
        else {
            let alertController = UIAlertController(title: "Required Section", message: "All sections are required", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    // since we have just 1 column - list of sports
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // number of sports
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // loads neighboring sports in picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // gets selected sport from picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sport = pickerData[row]
        //print(sport)
    }

   
   // sends an email consisting of 'message' to ALL the IDs in the arraylist 'emails'
   // works only on phones; not on simulator
   func sendEmail(emails:[String],message:String) {
        print(emails)
        print("<p>"+message+"</p>")
        if MFMailComposeViewController.canSendMail() {

            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            //mail.setToRecipients(["rohan27@uw.edu"])
            mail.setToRecipients(emails)
            mail.setMessageBody("<p>"+message+"</p>", isHTML: true)

            present(mail, animated: true)
            print("Email sent!")
        }
        else {
            print("Email not sent!")
        }
    }


    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func findMatches(){
    
        var matches = [String: String]()
        ref.child(zipcodeText).child(sport).observeSingleEvent(of: .value, with: { (snapshot) in
        let values = snapshot.value as! NSDictionary
            
        for (key, value) in values {

            let temp = value as! NSDictionary
            // adds an (email,ID) entry in dictionary
            matches[temp["email"] as! String] = key as? String
            
        }
        
        //Send email only if there's at least one match (Atleast one person other than the one entering right now)
        if(matches.count>1){
            let new_person_id = matches[self.given_email]
        
            matches.removeValue(forKey: self.given_email)
        
            //Send IDs of all old persons to this new person
            self.sendEmail(emails:Array(matches.keys),message:"New match for same sport in same zip code! ID = "+new_person_id!)
        
            var msg = ""
            for match in Array(matches.values){
                msg += "\n"
                msg += match
            }
            //Send this new person's ID to all old persons
            self.sendEmail(emails:[self.given_email],message:"Matches found for same sport in same zip code. IDs ="+msg+"\n")
            }
        else{
            print("No matches")
        }

    })
    {
    (error) in
        print(error.localizedDescription)
    }

    }
}
