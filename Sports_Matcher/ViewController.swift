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
        static let sport = "sport"
}

class ViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    var ref: FIRDatabaseReference!
    
    var sport: String = ""
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var zip_code: UITextField!
    
    @IBAction func submit(_ sender: Any) {
    submitAlert(message: "Are you sure all the information is correct and you want to submit now?", "Submit")
    }

    /*
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    */
    

    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = ["Football", "Baseball", "Soccer", "Volleyball", "Cricket", "Tennis", "Pool", "Thrwoball","Foosball","Swimming","Skating","Snowboarding"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        picker.dataSource = self
        picker.delegate = self
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
        self.storeInDB()

        /*
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
            //submit success alert and back to main screen
            
            //let data =  [Person.name: self.name.text! as String]
            
            //self.storeInDB(data: data)
            
        
            //self.name.resignFirstResponder()
        
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
    */
    }


    
    func storeInDB() {
        var data = [String: String]()
        
        if !name.text!.isEmpty && !email.text!.isEmpty && !zip_code.text!.isEmpty {
        //var data =  [Person.name: self.name.text! as String]
        data[Person.email] = email.text! as String

        data[Person.name] = name.text! as String
            
        data[Person.zip_code] = zip_code.text! as String
        
        data[Person.sport] = sport as String
        
        self.submitSuccessful()

        
        ref.child("Persons").childByAutoId().setValue(data)
                    self.name.text! = ""
            self.name.text! = ""
            self.email.text! = ""
            self.zip_code.text! = ""

        }
        
        else {
            let alertController = UIAlertController(title: "Required Section", message: "All sections are required", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        /*
        if !email.text!.isEmpty {
            data[Person.email] = email.text! as String
            
        }
        else {
         // create an alert - > Reqd field
         let alertController = UIAlertController(title: "Required Section", message: "Email address is a required field", preferredStyle: UIAlertControllerStyle.alert)
         alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
         self.present(alertController, animated: true, completion: nil)
         }

        
        if !zip_code.text!.isEmpty {
            data[Person.zip_code] = zip_code.text! as String
        
            data[Person.sport] = sport as String
            

        }
        else {
         // create an alert - > Reqd field
         let alertController = UIAlertController(title: "Required Section", message: "Zip Code is a required field", preferredStyle: UIAlertControllerStyle.alert)
         alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
         self.present(alertController, animated: true, completion: nil)
         }
*/
        

        

        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{        return pickerData.count
    }

//MARK: Delegates
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       sport = pickerData[row]
       return pickerData[row]
   }
    /*
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       myLabel.text = pickerData[row]
   }*/
}
