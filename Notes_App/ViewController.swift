//
//  ViewController.swift
//  Notes_App
//
//  Created by Yuvaraja Krishnamourthy Bhavani on 02/07/19.
//  Copyright © 2019 Yuvaraja Krishnamourthy Bhavani. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    var note: Notes?
    var data1:[String] = []
    var data2: [NSManagedObject] = []
    var selectedRow: Int = -1
    var newRowText:String = ""
    var fileURL:URL!
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table.dataSource = self
        table.delegate = self
        self.title = "NOTES"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        fileURL = baseURL.appendingPathComponent("notes.txt")
        //load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Notes")
        
        //3
        do {
            data2 = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if selectedRow == -1 {
            return
        }
        data1[selectedRow] = newRowText
        if newRowText == "" {
            data2.remove(at: selectedRow)
        }
        table.reloadData()
        save(content: data1[selectedRow])
    }
    
    @objc func addNote()
    {
        if (table.isEditing)
        {
            return
        }
        let name:String = ""
        data1.insert(name, at:0)
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "detail", sender: nil)
        save(content: data1[selectedRow])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = data2[indexPath.row]
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data.value(forKeyPath: "data") as? String
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated:animated)
        table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data2.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        save(content: data1[selectedRow])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        let detailView:DetailViewController = segue.destination as! DetailViewController
        selectedRow = table.indexPathForSelectedRow!.row
        detailView.masterView = self
        detailView.setText(t: data1[selectedRow])
    }
    
    func save()
    {
        //UserDefaults.standard.set(data, forKey: "notes")
//        let a = NSArray(array: data1)
//        do {
//            try a.write(to: fileURL)
//        } catch  {
//            print("Error failing to write the file")
//        }
    }
    
    func save(content: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Notes",
                                       in: managedContext)!
        
        let data = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        data.setValue(content, forKeyPath: "data")
        
        // 4
        do {
            try managedContext.save()
            data2.append(data)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
//    func load()
//    {
//        //if let loadedData:[String] = UserDefaults.standard.value(forKey: "notes") as? [String]
//        if let loadedData:[String] = NSArray(contentsOf: fileURL) as? [String]
//        {
//            data2 = loadedData
//            table.reloadData()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Core data
    func saveToCoreData(completion: @escaping ()->Void){
        managedObjectContext!.perform {
            do {
                try self.managedObjectContext?.save()
                completion()
                print("Note saved to CoreData.")
                
            }
                
            catch let error {
                print("Could not save note to CoreData: \(error.localizedDescription)")
                
            }
            
        }
        
    }
    


}

