//
//  ViewController.swift
//  Sports_Matcher
//
//  Created by Rohan Manoj Thakkar on 2/4/17.
//  Copyright © 2017 Rohan Manoj Thakkar. All rights reserved.
//

import UIKit
import Firebase

struct Person {
        static let name = "name"
        static let email = "email"
        static let zip_code = "zipcode"
}

class ViewController: UIViewController {
    var ref: FIRDatabaseReference!

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var zip_code: UITextField!
    @IBAction func submit(_ sender: Any) {
                submitAlert(message: "Are you sure all the information is correct and you want to submit now?", "Submit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()


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
            //self.do_table_refresh()
            NSLog(submitLog)}
        alertController.addAction(okAlert)
        self.present(alertController, animated: true, completion: nil);
    }

    
    func submitSuccessful(){
        alert(message: "submit successful", "submitted!")
    }
    
        //submit alert
    
    func submitAlert(message: String, _ submitLog:String){
        let alertController:UIAlertController = {
            return UIAlertController(title: "Submit", message: message, preferredStyle: UIAlertControllerStyle.alert)
        }()
        
        let okAlert:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (alert: UIAlertAction!) -> Void in
            /*
            for foodIndex in selected.items{
                foodItems.append(foodList.list[foodIndex])
            }
            */
            //submit success alert and back to main screen
            
            
            self.storeInDB()
            
            //self.eventName.resignFirstResponder()
            
            self.submitSuccessful()
            self.name.text! = ""
            self.email.text! = ""
            self.zip_code.text! = ""

            //self.do_table_refresh()
            
            NSLog(submitLog)
            }
    let cancelAlert:UIAlertAction = UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel) { (alert: UIAlertAction!) -> Void in
        }
        
        alertController.addAction(okAlert)
        alertController.addAction(cancelAlert)
        self.present(alertController, animated: true, completion: nil);
    }

    func storeInDB() {
        //var data = [FIRDataSnapshot]()

        if !name.text!.isEmpty {
        var data =  [Person.name: self.name.text! as String]

        //data[Person.name] = name.text! as String
            
        if !email.text!.isEmpty {
            data[Person.email] = email.text! as String
            
        if !zip_code.text!.isEmpty {
            data[Person.zip_code] = zip_code.text! as String
        
        ref.child("Persons").childByAutoId().setValue(data)

        }
        else {
         // create an alert - > Reqd field
         let alertController = UIAlertController(title: "Required Section", message: "Zip Code is a required field", preferredStyle: UIAlertControllerStyle.alert)
         alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
         self.present(alertController, animated: true, completion: nil)
         }
        }
        else {
         // create an alert - > Reqd field
         let alertController = UIAlertController(title: "Required Section", message: "Email address is a required field", preferredStyle: UIAlertControllerStyle.alert)
         alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
         self.present(alertController, animated: true, completion: nil)
         }

        }
        
        else {
            let alertController = UIAlertController(title: "Required Section", message: "Name is a required field", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        

        
        
        
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
