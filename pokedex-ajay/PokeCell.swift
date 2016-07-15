//
//  PokeCell.swift
//  pokedex-ajay
//
//  Created by Ajay Mann on 11/07/16.
//  Copyright © 2016 Ajay Mann. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    
    var pokemon : Pokemon!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5
        
    }
    
    func configureCell(pokemon : Pokemon) {
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalizedString
        thumbImg.image  = UIImage(named: "\(self.pokemon.pokedexId)")
        
        
    }
}
