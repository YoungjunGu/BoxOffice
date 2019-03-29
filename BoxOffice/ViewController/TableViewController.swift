//
//  TableViewController.swift
//  BoxOffice
//
//  Created by youngjun goo on 2018. 8. 8..
//  Copyright © 2018년 youngjun goo. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    //MARK:- Property
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var setBarButton: UIBarButtonItem!
    
    var refreshControl: UIRefreshControl?
    
    var movies: [Movie] = []
    let cellIdentify: String = "tableCell"
    
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentify, for: indexPath)
        if let tableCell = cell as? TableViewCell {
            
            guard indexPath.row < self.movies.count else {
                return cell
            }
            let movie: Movie = self.movies[indexPath.row]
            
            tableCell.configureTable(movie: movie, tableView: tableView, indexPath: indexPath)
        
            return tableCell
        } else {
            print("cell == nil")
            return cell
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestMovies(addURL: "1")
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
    }
}

//MARK:- IBAction
extension TableViewController {
    
    @IBAction func touchUpShowActionSheetButton(_ sender: UIBarButtonItem) {
        self.showAlertController(style: UIAlertControllerStyle.actionSheet)
    }
}

//MARK:- Method
extension TableViewController {
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(refreshControl!)
       
    }
    
    @objc func refreshTable() {
        self.tableView.reloadSections(IndexSet(0...0), with: UITableViewRowAnimation.automatic)
        refreshControl?.endRefreshing()
    }
    
    
    func showAlertController(style: UIAlertControllerStyle) {
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let orderGrageAction: UIAlertAction
        orderGrageAction = UIAlertAction(title: "예매율", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            self.requestMovies(addURL: "0")
        })
        
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(orderGrageAction)
        alertController.addAction(cancelAction)
    
        
        let orderCurationAction: UIAlertAction
        orderCurationAction = UIAlertAction(title: "큐레이션", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            self.requestMovies(addURL: "1")
        })
        
        let orderDateAction: UIAlertAction
        orderDateAction = UIAlertAction(title: "개봉일", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            self.requestMovies(addURL: "2")
        })
        
        alertController.addAction(orderCurationAction)
        alertController.addAction(orderDateAction)
        

        
        self.present(alertController, animated: true, completion: {
            print("Alert controller shown")
        })
        
    }
    
    func requestMovies(addURL: String) {
        
        Request.requestURL(addURL: addURL) { (movies: [Movie]?) in
            if let movies = movies {
                self.movies = movies
                self.tableView.reloadSections(IndexSet(0...0), with: UITableViewRowAnimation.automatic)
            }
        }
    
    }
    
}

extension TableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "showMovieInfo" else { return }
        
        guard let cell: TableViewCell = sender as? TableViewCell else { return }
        
        guard let index: IndexPath = self.tableView.indexPath(for: cell) else { return }
        
        guard index.row < self.movies.count else {
            return
        }
        
        guard let InfoVC: InfoTableViewController = segue.destination as? InfoTableViewController else {
            return
        }
        
        let movie: Movie = self.movies[index.row]
        
        InfoVC.movie = movie
        
        
    }
}











