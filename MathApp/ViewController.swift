//
//  ViewController.swift
//  MathApp
//
//  Created by Pavel Koyushev on 05.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collection: UICollectionView!
    private let tableIdentifier = "cell"
    
    private var numbers = [Int]()
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var index = 0
        while index < 40 {
            if isPrime(index) == true {
                numbers.append(index)
            }
            index += 1
        }
    }
    
    func isPrime(_ number: Int) -> Bool {
        return number > 1 && !(2..<number).contains { number % $0 == 0 }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tableIdentifier, for: indexPath) as! NumbersCollectionViewCell
        cell.numberLabel.text = "\(self.numbers[indexPath.item])"
        
//        var cellColor: UIColor
//
//        if indexPath.item % 4 == 0 {
//            cellColor = UIColor.gray
//        } else {
//            cellColor = UIColor.white
//        }
//
//        cell.backgroundColor = cellColor
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isLoading {
                isLoading = true
                
                let next = (self.numbers.last!+1...self.numbers.last! + 100).map { $0 }
                for index in next {
                    if self.isPrime(index) == true {
                        self.numbers.append(index)
                    }
                }
                isLoading = false
                self.collection.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return numbers.count
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sizeHeight: CGFloat = 0.0
        var sizeWidth: CGFloat = 0.0
        
        if UIDevice.current.orientation.isLandscape {//пейзаж
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            sizeWidth = (collection.frame.size.width-10) / 3.0
            sizeHeight = (collection!.bounds.height) / 2.0
        } else if UIDevice.current.orientation.isPortrait {//портрет
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            sizeWidth = (collection.frame.size.width - space) / 2.0
            sizeHeight = (collection!.bounds.height) / 5.0
        }
        
        return CGSize(width: sizeWidth, height: sizeHeight)
    }
}

