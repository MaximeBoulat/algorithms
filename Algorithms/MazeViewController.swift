//
//  MazeViewController.swift
//  Algorithms
//
//  Created by Maxime Boulat on 2/3/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

import UIKit

enum TileType {
    case pilot
    case startingPoint
    case goal
    case path
    case none
}

enum Direction: Int {
    case north
    case south
    case east
    case west
}

class GameTile {
    var isWall: Bool = false
    var visited: Bool = false
    var type: TileType = .none
    var score: Int = -1
    var row: Int = 0
    var column: Int = 0
    var neighbors: [GameTile] = []
    
}

class MazeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    private let reuseIdentifier = "Cell"
    private var insetValue: CGFloat = 15
    private var boardWidth: Int = 23
    
    private var gameWorld: GameWorld!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.gameWorld = GameWorld(horizontalSpan: self.boardWidth, inset: self.insetValue, view: self.view)
        self.startSimulation()
        
    }
    
    // MARK: - CollectionView methods
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gameWorld.totalTiles
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TileCollectionViewCell
        
        // get row and column
        let row = indexPath.row / self.gameWorld.horizontalSpan
        let column = indexPath.row % self.gameWorld.horizontalSpan
        
        // get corresponding data item
        let gametile = self.gameWorld.grid[row][column]
        
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
        self.gameWorld = GameWorld(horizontalSpan: self.boardWidth, inset: self.insetValue, view: self.view)
        self.startSimulation()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - self.insetValue * 2) / CGFloat(self.gameWorld.horizontalSpan)
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
    
    // MARK: Simulation
    
    private func startSimulation() {
        
        
        let dfs = DFS(position: (row: 1, column: 1), gameWorld: self.gameWorld)
        
        dfs.traverse {
            self.collectionView!.reloadData()
        } completion: {
            self.gameWorld.setMarkers()
            
            let bfs = BFS(startingPoint: self.gameWorld.startingPoint, goal: self.gameWorld.goal)
            
            bfs.traverse {
                self.collectionView!.reloadData()
            }
        }
        
    }
}

// MARK: Agents

class DFS {
    
    var position: (row: Int, column: Int)
    var frontier: [GameTile] = []
    
    var tilesVisited: Int = 0
    
    var gameWorld: GameWorld
    
    var currentTile: GameTile {
        return gameWorld.grid[position.row][position.column]
    }
    
    init(position: (row: Int, column: Int), gameWorld: GameWorld) {
        self.position = position
        self.gameWorld = gameWorld
        
        self.currentTile.visited = true
        self.frontier.append( self.currentTile)
        self.tilesVisited += 1
    }
    
    private func canMove(direction: Direction) -> Bool {
        switch direction {
        case .north:
            return position.row - 2 > 0
        case .east:
            return position.column + 2 < gameWorld.horizontalSpan
        case .south:
            return position.row + 2 < gameWorld.grid.count
        case .west:
            return position.column - 2 > 0
        }
    }
    
    private func calculateDestination(direction: Direction) -> (row: Int, column: Int) {
        
        var destination: (row: Int, column: Int)
        
        switch direction {
        case .north:
            destination = (row: position.row - 2, column: position.column)
        case .east:
            destination = (row: position.row, column: position.column + 2)
        case .south:
            destination = (row: position.row + 2, column: position.column)
        case .west:
            destination = (row: position.row, column: position.column - 2)
        }
        
        return destination
    }
    
    func traverse(update: @escaping () -> Void, completion: @escaping () -> Void) {
        
        DispatchQueue.global(qos: .default).async {
            
            var directions = [Direction.west, Direction.north, Direction.east, Direction.south]
            
            
            while self.tilesVisited < self.gameWorld.blankTiles {
                
                
                let randomIndex = Int.random(in: 0..<directions.count)
                let currentDirection = directions.remove(at: randomIndex)
                
                // check boundaries
                if self.canMove(direction: currentDirection) {
                    
                    // check visited
                    let destination = self.calculateDestination(direction: currentDirection)
                    let destinationTile = self.gameWorld.grid[destination.0][destination.1]
                    
                    if !destinationTile.visited {
                        
                        // remove wall
                        let wall = self.gameWorld.teardownWall(between: self.position, and: destination)
                        
                        // Build the next graph
                        wall.neighbors.append(self.currentTile)
                        self.currentTile.neighbors.append(wall)
                        wall.neighbors.append(destinationTile)
                        destinationTile.neighbors.append(wall)
                        
                        // move
                        self.currentTile.type = .none
                        self.position = destination
                        self.currentTile.type = .pilot
                        
                        // Update state
                        self.currentTile.visited = true
                        self.tilesVisited += 1
                        self.frontier.insert(self.currentTile, at: 0)
                        directions = [Direction.west, Direction.north, Direction.east, Direction.south]
                        
                    }
                }
                
                if directions.isEmpty {
                    
                    self.frontier.removeFirst()
                    self.currentTile.type = .none
                    
                    let next = self.frontier[0]
                    self.position = (row: next.row, column: next.column)
                    self.currentTile.type = .pilot
                    directions = [Direction.west, Direction.north, Direction.east, Direction.south]
                }
                
                DispatchQueue.main.sync {
                    update()
                }
                
            }
            
            self.currentTile.type = .none
            
            
            DispatchQueue.main.async {
                completion()
            }
            
        }
        
    }
}

class BFS {
    
    private var frontier: [GameTile] = []
    
    private var startingPoint: GameTile
    private var goal: GameTile
    
    
    init(startingPoint: GameTile, goal: GameTile) {
        self.startingPoint = startingPoint
        self.goal = goal
    }
    
    func traverse(update: @escaping () -> Void) {
        
        DispatchQueue.global(qos: .default).async {
            
            self.startingPoint.score = 0
            self.frontier.append(self.startingPoint)
            
            while !self.frontier.isEmpty {
                let currentTile = self.frontier.removeFirst()
                
                for neighbor in currentTile.neighbors {
                    if neighbor.score < 0 {
                        neighbor.score = currentTile.score + 1
                        self.frontier.append(neighbor)
                        
                    }
                }
                
                DispatchQueue.main.sync {
                    update()
                }
                
                
            }
            
            // now starting at the end point, rewind to stroke the path
            
            var currentTile = self.goal
            
            while currentTile !== self.startingPoint {
                for neighbor in currentTile.neighbors {
                    if neighbor.score < currentTile.score {
                        if neighbor !== self.startingPoint {
                            neighbor.type = .path
                        }
                        currentTile = neighbor
                        break
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            update()
        }
        
    }
    
    
}

class GameWorld {
    
    
    var grid: [[GameTile]] = []
    
    var horizontalSpan: Int
    
    var totalTiles: Int = 0
    var blankTiles: Int = 0
    
    var startingPoint: GameTile!
    var goal: GameTile!
    
    init(horizontalSpan: Int, inset: CGFloat, view: UIView) {
        
        let widthOfItem = (view.frame.size.width - inset * 2) / CGFloat(horizontalSpan)
        let safeAreaInsets = view.safeAreaInsets
        let availableHeight = view.frame.size.height - safeAreaInsets.top - safeAreaInsets.bottom - (2 * inset)
        let numberOfItemsDeep = Int(Double(availableHeight) / Double(widthOfItem))
        let totalTiles = numberOfItemsDeep * horizontalSpan
        
        var blankTiles = 0
        
        for i in 0..<numberOfItemsDeep {
            var array: [GameTile] = []
            for l in 0..<horizontalSpan {
                let tile = GameTile()
                tile.row = i
                tile.column = l
                if i % 2 == 0 || l % 2 == 0 {
                    tile.isWall = true
                } else {
                    blankTiles += 1
                }
                array.append(tile)
            }
            self.grid.append(array)
        }
        
        self.horizontalSpan = horizontalSpan
        self.totalTiles = totalTiles
        self.blankTiles = blankTiles
    }
    
    func teardownWall(between: (row: Int, column: Int), and: (row: Int, column: Int)) -> GameTile {
        let wallRow = (between.row + and.row) / 2
        let wallColumn = (between.column + and.column) / 2
        
        let wall = self.grid[wallRow][wallColumn]
        wall.isWall = false
        return wall
    }
    
    func setMarkers() {
        
        // pick random row and column for start until you get an empty tile
        var randomRow = Int(arc4random_uniform(UInt32(self.grid.count)))
        var randomColumn = Int(arc4random_uniform(UInt32(self.horizontalSpan)))
        var tile = self.grid[randomRow][randomColumn]
        
        while tile.isWall {
            randomRow = Int(arc4random_uniform(UInt32(self.grid.count)))
            randomColumn = Int(arc4random_uniform(UInt32(self.horizontalSpan)))
            tile = self.grid[randomRow][randomColumn]
        }
        
        tile.type = .startingPoint
        self.startingPoint = tile
        
        // pick random row and column for goal until you get an empty tile
        randomRow = Int(arc4random_uniform(UInt32(self.grid.count)))
        randomColumn = Int(arc4random_uniform(UInt32(self.horizontalSpan)))
        tile = self.grid[randomRow][randomColumn]
        
        while tile.isWall {
            randomRow = Int(arc4random_uniform(UInt32(self.grid.count)))
            randomColumn = Int(arc4random_uniform(UInt32(self.horizontalSpan)))
            tile = self.grid[randomRow][randomColumn]
        }
        
        tile.type = .goal
        self.goal = tile
        
    }
    
}



