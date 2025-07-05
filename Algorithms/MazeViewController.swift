//
//  MazeViewController.swift
//  Algorithms
//
//  Created by Maxime Boulat on 2/3/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

import UIKit

enum TileType: Int {
    case pilot = 0
    case startingPoint
    case goal
    case path
    case none
}

enum Direction: Int {
    case north = 0
    case south
    case east
    case west
}

class GameTile: NSObject {
    var isWall: Bool = false
    var visited: Bool = false
    var type: TileType = .none
    var score: Int = -1
    var row: Int = 0
    var column: Int = 0
    var neighbors: [GameTile] = []
    
    override init() {
        super.init()
        self.isWall = false
        self.visited = false
        self.type = .none
        self.neighbors = []
        self.score = -1
    }
}

class MazeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    private let reuseIdentifier = "Cell"
    private var insetValue: CGFloat = 15
    private var numberOfItemsAcross: Int = 23
    private var datasourceCount: Int = 0
    private var datasource: [[GameTile]] = []
    private var startingPoint: GameTile?
    private var goal: GameTile?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.insetValue = 15
        self.numberOfItemsAcross = 23
        self.datasource = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        makeDataSource()
        makeMaze()
    }
    
    // MARK: - CollectionView methods
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasourceCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TileCollectionViewCell
        
        // get row and column
        let row = indexPath.row / self.numberOfItemsAcross
        let column = indexPath.row % self.numberOfItemsAcross
        
        // get corresponding data item
        let gametile = self.datasource[row][column]
        
        if gametile.isWall {
            cell.tileView.backgroundColor = UIColor.lightGray
        } else {
            cell.tileView.backgroundColor = UIColor.white
        }
        
        switch gametile.type {
        case .pilot, .path:
            cell.tileView.backgroundColor = UIColor.blue
        case .startingPoint:
            cell.tileView.backgroundColor = UIColor.green
        case .goal:
            cell.tileView.backgroundColor = UIColor.red
        default:
            break
        }
        
        if gametile.isWall || gametile.score < 0 {
            cell.theLabel.isHidden = true
        } else {
            cell.theLabel.isHidden = false
            cell.theLabel.text = "\(gametile.score)"
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        makeDataSource()
        makeMaze()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - self.insetValue * 2) / CGFloat(self.numberOfItemsAcross)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.insetValue, left: self.insetValue, bottom: self.insetValue, right: self.insetValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Path finding
    
    private func makeMaze() {
        DispatchQueue.global(qos: .default).async {
            
            var northChecked = false
            var westChecked = false
            var southChecked = false
            var eastChecked = false
            
            var totalTiles = 0
            var tilesVisited = 1
            
            var undoStack: [GameTile] = []
            
            var previous = self.datasource[1][1]
            previous.visited = true
            undoStack.append(previous)
            
            for row in self.datasource {
                for tile in row {
                    if !tile.isWall {
                        totalTiles += 1
                    }
                }
            }
            
            while true {
                let currentDirection = Direction(rawValue: Int(arc4random_uniform(4)))!
                
                switch currentDirection {
                case .north:
                    if northChecked {
                        continue
                    }
                    
                    // check if two spaces north is available
                    if previous.row - 2 <= 0 {
                        northChecked = true
                    } else {
                        let newRow = previous.row - 2
                        
                        // get the corresponding tile
                        let tile = self.datasource[newRow][previous.column]
                        
                        if tile.visited {
                            northChecked = true
                        } else {
                            northChecked = false
                            southChecked = false
                            westChecked = false
                            eastChecked = false
                            
                            tilesVisited += 1
                            // Get the wall, tear it down
                            let wall = self.datasource[previous.row - 1][previous.column]
                            wall.isWall = false
                            // update tile
                            tile.visited = true
                            
                            wall.neighbors.append(previous)
                            previous.neighbors.append(wall)
                            tile.neighbors.append(wall)
                            wall.neighbors.append(tile)
                            
                            undoStack.insert(tile, at: 0)
                            previous.type = .none
                            previous = tile
                            previous.type = .pilot
                        }
                    }
                    
                case .east:
                    if eastChecked {
                        continue
                    }
                    
                    if previous.column + 2 >= self.numberOfItemsAcross {
                        eastChecked = true
                    } else {
                        let newColumn = previous.column + 2
                        let tile = self.datasource[previous.row][newColumn]
                        if tile.visited {
                            eastChecked = true
                        } else {
                            northChecked = false
                            southChecked = false
                            westChecked = false
                            eastChecked = false
                            
                            tilesVisited += 1
                            // Get the wall, tear it down
                            let wall = self.datasource[previous.row][previous.column + 1]
                            wall.isWall = false
                            // update tile
                            tile.visited = true
                            
                            wall.neighbors.append(previous)
                            previous.neighbors.append(wall)
                            tile.neighbors.append(wall)
                            wall.neighbors.append(tile)
                            
                            undoStack.insert(tile, at: 0)
                            previous.type = .none
                            previous = tile
                            previous.type = .pilot
                        }
                    }
                    
                case .south:
                    if southChecked {
                        continue
                    }
                    
                    // check if two spaces south is available
                    if previous.row + 2 >= self.datasource.count {
                        southChecked = true
                    } else {
                        let newRow = previous.row + 2
                        
                        // get the corresponding tile
                        let tile = self.datasource[newRow][previous.column]
                        if tile.visited {
                            southChecked = true
                        } else {
                            northChecked = false
                            southChecked = false
                            westChecked = false
                            eastChecked = false
                            
                            tilesVisited += 1
                            // Get the wall, tear it down
                            let wall = self.datasource[previous.row + 1][previous.column]
                            wall.isWall = false
                            // update tile
                            tile.visited = true
                            
                            wall.neighbors.append(previous)
                            previous.neighbors.append(wall)
                            tile.neighbors.append(wall)
                            wall.neighbors.append(tile)
                            
                            undoStack.insert(tile, at: 0)
                            previous.type = .none
                            previous = tile
                            previous.type = .pilot
                        }
                    }
                    
                case .west:
                    if westChecked {
                        continue
                    }
                    
                    if previous.column - 2 <= 0 {
                        westChecked = true
                    } else {
                        let newColumn = previous.column - 2
                        let tile = self.datasource[previous.row][newColumn]
                        if tile.visited {
                            westChecked = true
                        } else {
                            northChecked = false
                            southChecked = false
                            westChecked = false
                            eastChecked = false
                            
                            tilesVisited += 1
                            // Get the wall, tear it down
                            let wall = self.datasource[previous.row][previous.column - 1]
                            wall.isWall = false
                            // update tile
                            tile.visited = true
                            
                            wall.neighbors.append(previous)
                            previous.neighbors.append(wall)
                            tile.neighbors.append(wall)
                            wall.neighbors.append(tile)
                            
                            undoStack.insert(tile, at: 0)
                            previous.type = .none
                            previous = tile
                            previous.type = .pilot
                        }
                    }
                }
                
                if northChecked && southChecked && eastChecked && westChecked {
                    undoStack.removeFirst()
                    previous.type = .none
                    previous = undoStack[0]
                    previous.type = .pilot
                    northChecked = false
                    southChecked = false
                    westChecked = false
                    eastChecked = false
                }
                
                DispatchQueue.main.sync {
                    self.collectionView!.reloadData()
                }
                
                if tilesVisited >= totalTiles {
                    previous.type = .none
                    break
                }
            }
            
            DispatchQueue.main.sync {
                self.setMarkers()
            }
        }
    }
    
    private func setMarkers() {
        
        // pick random row and column for start until you get an empty tile
        var randomRow = Int(arc4random_uniform(UInt32(self.datasource.count)))
        var randomColumn = Int(arc4random_uniform(UInt32(self.numberOfItemsAcross)))
        var tile = self.datasource[randomRow][randomColumn]
        
        while tile.isWall {
            randomRow = Int(arc4random_uniform(UInt32(self.datasource.count)))
            randomColumn = Int(arc4random_uniform(UInt32(self.numberOfItemsAcross)))
            tile = self.datasource[randomRow][randomColumn]
        }
        
        tile.type = .startingPoint
        self.startingPoint = tile
        
        self.collectionView!.reloadData()
        
        // pick random row and column for goal until you get an empty tile
        randomRow = Int(arc4random_uniform(UInt32(self.datasource.count)))
        randomColumn = Int(arc4random_uniform(UInt32(self.numberOfItemsAcross)))
        tile = self.datasource[randomRow][randomColumn]
        
        while tile.isWall {
            randomRow = Int(arc4random_uniform(UInt32(self.datasource.count)))
            randomColumn = Int(arc4random_uniform(UInt32(self.numberOfItemsAcross)))
            tile = self.datasource[randomRow][randomColumn]
        }
        
        tile.type = .goal
        self.goal = tile
        
        self.collectionView!.reloadData()
        findPath()
    }
    
    private func isOutOfBounds(row: Int, column: Int) -> Bool {
        return row <= 0 || column >= self.numberOfItemsAcross || column <= 0 || row >= self.datasource.count
    }
    
    private func findPath() {
        
        DispatchQueue.global(qos: .default).async {
            
            var queue: [GameTile] = []
            self.startingPoint?.score = 0
            if let startingPoint = self.startingPoint {
                queue.append(startingPoint)
            }
            
            while !queue.isEmpty {
                let currentTile = queue.removeFirst()
                
                for neighbor in currentTile.neighbors {
                    if neighbor.score < 0 {
                        neighbor.score = currentTile.score + 1
                        queue.append(neighbor)
                    }
                }
                
                DispatchQueue.main.sync {
                    self.collectionView!.reloadData()
                }
            }
            
            // now starting at the end point, rewind to stroke the path
            guard let goal = self.goal, let startingPoint = self.startingPoint else { return }
            
            var currentTile = goal
            
            while currentTile !== startingPoint {
                for neighbor in currentTile.neighbors {
                    if neighbor.score < currentTile.score {
                        if neighbor !== startingPoint {
                            neighbor.type = .path
                        }
                        currentTile = neighbor
                        break
                    }
                }
            }
            
            DispatchQueue.main.sync {
                self.collectionView!.reloadData()
            }
        }
    }
    
    private func makeDataSource() {
        
        self.datasource.removeAll()
        
        let widthOfItem = (self.view.frame.size.width - self.insetValue * 2) / CGFloat(self.numberOfItemsAcross)
        let availableHeight = Int(self.view.frame.size.height - (2 * self.insetValue))
        let numberOfItemsDeep = Int(Double(availableHeight) / Double(widthOfItem))
        self.datasourceCount = numberOfItemsDeep * self.numberOfItemsAcross
        
        for i in 0..<numberOfItemsDeep {
            var array: [GameTile] = []
            for l in 0..<self.numberOfItemsAcross {
                let tile = GameTile()
                tile.row = i
                tile.column = l
                if i % 2 == 0 || l % 2 == 0 {
                    tile.isWall = true
                }
                array.append(tile)
            }
            self.datasource.append(array)
        }
    }
} 
