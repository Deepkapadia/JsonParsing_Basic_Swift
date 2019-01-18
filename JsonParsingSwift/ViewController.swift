//
//  ViewController.swift
//  JsonParsingSwift
//
//  Created by MACOS on 6/17/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController,URLSessionDelegate,UITableViewDataSource,UITableViewDelegate{

    var arr = [String]();
    
    @IBOutlet weak var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22nome%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys");
        
        let request = URLRequest(url: url!);
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil);
        
        let task = session.dataTask(with: request) { (data, response, nil) in
            
            do
            {
                let test = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as Any;
                
                //print(test);
                
                let dic = test as! Dictionary<String,Any>;
                
                let dic1 = dic["temperature"] as! Dictionary<String,Any>;
                
                let dic3 = dic1["speed"]  as! Dictionary<String,Any>
                
                let brr = dic3["results"] as! [[String:Any]];
                
                //to display in tableview
                DispatchQueue.main.async {
                    
                    for i in 0 ..< brr.count{
                        
                        let name = brr[i]["series_name"] as! String;
                        self.arr.append(name);
                        
                    }
                    
                    self.tbl.reloadData();
                    
                    //print(self.arr);
                }
                
            }
            catch
            {
                
            }
        }
        task.resume();
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arr.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        
        //let dic = arr[indexPath.row] as! Dictionary<String,Any>;
        
        cell?.textLabel?.text = arr[indexPath.row] as String?;
        
        return cell!;
    }

}

