//
//  ViewController.swift
//  pokedex-ajay
//
//  Created by Ajay Mann on 09/07/16.
//  Copyright © 2016 Ajay Mann. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UISearchBarDelegate{

    @IBOutlet weak var collection :  UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var musicplayer : AVAudioPlayer!
    
    var inSearchMode = false
    var fileteredPokemon = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view, typically from a nib.
//        var pokemon = Pokemon(name : "Charizard", pokedexId : 6)
//        print (pokemon.name)
//        print(pokemon.pokedexId)
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        initAudio()
        parsePokemonCSV()
        print(pokemon.count)
    }

    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            musicplayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicplayer.prepareToPlay()
            musicplayer.numberOfLoops = -1
            musicplayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            let poke : Pokemon!
            
            if inSearchMode {
                poke = fileteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            cell.configureCell(poke)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke : Pokemon!
        if inSearchMode {
            poke = fileteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return fileteredPokemon.count
        }
        return pokemon.count
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(90, 90)
        
    }
    
    func parsePokemonCSV() {
        let path  = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId  = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name , pokedexId: pokeId)
                pokemon.append(poke)
            }
        } catch let err as NSError {
            print (err.debugDescription)
        }
    }
    
    
    @IBAction func musicBtnPressed(sender: UIButton!) {
        
        if musicplayer.playing{
            musicplayer.stop()
            sender.alpha = 0.2
            
        } else {
            musicplayer.play()
            sender.alpha = 1.0
        }
    
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text  == "" {
            
            inSearchMode = false
            
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            
            fileteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            collection.reloadData()
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
}

