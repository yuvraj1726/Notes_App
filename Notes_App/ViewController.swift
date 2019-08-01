//
//  ViewController.swift
//  Notes_App
//
//  Created by Yuvaraja Krishnamourthy Bhavani on 02/07/19.
//  Copyright © 2019 Yuvaraja Krishnamourthy Bhavani. All rights reserved.
//

import UIKit
import CoreData
@available(iOS 11.0, *)
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    var data2 = [NSManagedObject]()
    var selectedRow: Int = -1
    var newRowText:String = ""
    var newRowText1:String = ""
    var notes  = [Notes]()
    var ip: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table.dataSource = self
        table.delegate = self
        self.title = "NOTES"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //self.navigationItem.largeTitleDisplayMode = .always
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1 {
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        print(selectedRow)
        data2[selectedRow].setValue(newRowText, forKey: "newRowText2")
        data2[selectedRow].setValue(newRowText1, forKey: "newRowText3")
        if newRowText == ""{
            managedContext.delete(data2[selectedRow])
            data2.remove(at: selectedRow)
       }
        save()
        load()
        table.reloadData()
    }
    
    @objc func addNote()
    {
        if (table.isEditing)
        {
            return
        }
        let name: String = ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: managedContext)
        let newRowText2 = NSManagedObject(entity: entity!, insertInto: managedContext)
        newRowText2.setValue(name, forKey: "newRowText2")
        newRowText2.setValue(name, forKey: "newRowText3")
        data2.append(newRowText2)
        save()
        let indexPath:IndexPath = IndexPath(row: data2.count-1, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "detail", sender: nil)
        return
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if data2[indexPath.row].value(forKey: "newRowText3") as! String == ""
        {
            cell.textLabel?.text = data2[indexPath.row].value(forKey: "newRowText2") as? String
            return cell
        }
        else
        {
            cell.textLabel?.text = data2[indexPath.row].value(forKey: "newRowText3") as? String
           return cell
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        setIndexPath(i: indexPath)
        load()
        dialogOKCancel(i1:indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        let detailView:DetailViewController = segue.destination as! DetailViewController
        selectedRow = table.indexPathForSelectedRow!.row
        detailView.masterView = self
        load()
        detailView.setText(t:(data2[selectedRow].value(forKey: "newRowText2") as! String?)!,t1:(data2[selectedRow].value(forKey: "newRowText3") as! String?)!)
    }
    
    func save()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
           try managedContext.save()
        } catch  {
            print("Error failing to write the file")
        }
    }
    
    func load()
    {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
    do {
    try notes = managedContext.fetch(fetchRequest) as! [Notes]
        data2 = notes as [NSManagedObject]
    }
    catch {
    print("error")
   }
    table.reloadData()
        
    }
    
    func dialogOKCancel(i1:IndexPath)    {
        
        let alert = UIAlertController(title: "Do you want to delete the note?", message: "Note will be deleted", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Delete", style: .default, handler: { action in self.delete()})
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func delete() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let j = getIndexPath()
        managedContext.delete(data2[j.row])
        data2.remove(at: j.row)
        table.deleteRows(at: [j], with: .fade)
        save()
    }
    
    func setIndexPath(i:IndexPath )
    {
     ip = i
    }
    func getIndexPath() -> IndexPath
    {
        return ip
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

