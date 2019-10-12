//
//  TPDirectViewController.swift
//  STYLiSH
//
//  Created by 陸瑋恩 on 2019/7/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

class TPDirectViewController: UIViewController {
    
    @IBOutlet weak var cardInfoView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var tpdForm: TPDForm!
    var tpdCard: TPDCard!
    
    let checkOutManager = CheckOutManager()

    var checkOutInfo: CheckOutInfo!
    var userToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tpdForm = TPDForm.setup(withContainer: cardInfoView)
        
        tpdForm.onFormUpdated { (status) in
            
            self.confirmButton.isEnabled = status.isCanGetPrime()
            self.confirmButton.alpha = status.isCanGetPrime() ? 1.0 : 0.25
        }
        
        confirmButton.alpha = 0.25
    }
    
    @IBAction func getPrime() {
        
        tpdCard = TPDCard.setup(tpdForm)

        tpdCard.onSuccessCallback { (prime, _, _) in

            if let prime = prime {
                self.checkOutInfo.prime = prime
            }
            
            self.checkOutManager.postCheckOutInfo(with: self.checkOutInfo, userToken: self.userToken)
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            
        }.onFailureCallback { (status, message) in

            print("status : \(status) , Message : \(message)")

        }.getPrime()
    }
}
