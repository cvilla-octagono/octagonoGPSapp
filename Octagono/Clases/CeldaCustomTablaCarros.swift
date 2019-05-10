//
//  CeldaCustomTablaCarros.swift
//  Octagono
//
//  Created by Christian Villa Rhode on 1/31/19.
//  Copyright © 2019 Christian Villa Rhode. All rights reserved.
//

import UIKit

class CeldaCustomTablaCarros: UITableViewCell {

    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var ultimavex: UILabel!
    @IBOutlet weak var placa: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
