//
//  DiscoverVC.swift
//  GroomedStoryboard
//
//  Created by Mohammad Ashraful Islam Sadi on 8/10/20.
//

import UIKit

class DiscoverVC: UIViewController {
    
    @IBOutlet weak var bestSpecialistCollectionView: UICollectionView!
    
    var bestSpecialistList: [BestSpecialistDataModel] = [
        BestSpecialistDataModel(specialistImage: #imageLiteral(resourceName: "Specialist1"), specialistName: "Sadi Ashraful", specialistJobTitle: "Hair Stylist"),
        BestSpecialistDataModel(specialistImage: #imageLiteral(resourceName: "Specialist2"), specialistName: "Farzana Shakeel", specialistJobTitle: "Makeup Artist"),
        BestSpecialistDataModel(specialistImage: #imageLiteral(resourceName: "Specialist3"), specialistName: "Usman Haider", specialistJobTitle: "Barber")
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bestSpecialistCollectionView.delegate = self
        bestSpecialistCollectionView.dataSource = self
        
    }
}

extension DiscoverVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSpecialistCell", for: indexPath) as! BestSpecialistCell
        let bestSpecialist = bestSpecialistList[indexPath.row]
        cell.specialistImage.image = bestSpecialist.specialistImage
        cell.specialistName.text = bestSpecialist.specialistName
        cell.specialistJobTitle.text = bestSpecialist.specialistJobTitle
        return cell
    }
}

class BestSpecialistCell: UICollectionViewCell {
    @IBOutlet weak var specialistImage: UIImageView!
    @IBOutlet weak var specialistName: UILabel!
    @IBOutlet weak var specialistJobTitle: UILabel!
    
}

struct BestSpecialistDataModel {
    var specialistImage: UIImage?
    var specialistName: String?
    var specialistJobTitle: String?
}
