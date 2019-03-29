//
//  CollectionViewController.swift
//  BoxOffice
//
//  Created by youngjun goo on 2018. 8. 8..
//  Copyright © 2018년 youngjun goo. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    //MARK:- Property
    @IBOutlet weak var setBarButton: UIBarButtonItem!
    
    var refreshControl: UIRefreshControl?
    
    var movies: [Movie] = []
    let cellIdentify: String = "collectionCell"
    
    var cellSize: CGSize!
    
    
}

//MARK:- UICollectionViewDataSource
extension CollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentify, for: indexPath)
        
        if let collectionCell = cell as? CollectionViewCell {
            
            guard indexPath.row < self.movies.count else {
                return cell
            }
            let movie: Movie = self.movies[indexPath.row]
            
            collectionCell.configureTable(movie: movie, collectionView: collectionView, indexPath: indexPath)
            
            return collectionCell
        } else {
            print("cell==nil")
            return cell
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cellSize = CGSize(width: 180 , height: 300)
        requestMovies(addURL: "1")
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         addRefreshControl()
    }
    
}

// MARK:- UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func updateViews() {
        let viewSize = self.view.frame.size
        //뷰의 회전을 감지하고 셀을 재배열
        if(UIApplication.shared.statusBarOrientation.isPortrait) {
            let cellLength = (viewSize.width/2.0) - 1
            self.cellSize = CGSize(width: cellLength, height: cellLength)
        } else {
            let cellLength = (viewSize.width/3.0) - 1
            self.cellSize = CGSize(width: cellLength, height: cellLength)
        }
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
}

//MARK:- IBAction
extension CollectionViewController {
    
    @IBAction func touchupShowActionSheetButton(_ sender: UIBarButtonItem) {
        self.showAlertController(style: UIAlertControllerStyle.actionSheet)
    }
}

//MARK:- Method
extension CollectionViewController {
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshCell), for: .valueChanged)
        collectionView?.addSubview(refreshControl!)
        
    }
    
    @objc func refreshCell() {
        self.collectionView?.reloadSections(IndexSet(0...0))
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
                self.collectionView?.reloadSections(IndexSet(0...0))
            }
        }
        
    }
    
}

extension CollectionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "showMovieInfo" else { return }
        
        guard let cell: CollectionViewCell = sender as? CollectionViewCell else { return }
        
        guard let index: IndexPath = collectionView?.indexPath(for: cell) else { return }
        
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





