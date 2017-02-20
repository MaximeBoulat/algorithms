//
//  GameCollectionViewController.m
//  Algorithms
//
//  Created by Maxime Boulat on 2/3/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import "MazeViewController.h"
#import "TileCollectionViewCell.h"
#import "AlgorithmManager.h"
#import "Algorithms-Swift.h"

@interface MazeViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGFloat insetValue;
@property (nonatomic, assign) int numberOfItemsAcross;
@property (nonatomic, assign) int datasourceCount;

@property (nonatomic, retain) NSMutableArray <NSMutableArray *> * datasource;

@property (nonatomic, retain) GameTile * startingPoint;
@property (nonatomic, retain) GameTile * goal;
@property (nonatomic, strong) EnumeratorSwift * enumerator;

@end


typedef NS_ENUM(NSInteger, Direction) {
	north = 0,
	south,
	east,
	west
};


@implementation MazeViewController

static NSString * const reuseIdentifier = @"Cell";


#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.insetValue = 15;
	self.numberOfItemsAcross = 23;
	
	self.datasource = [NSMutableArray new];
	
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self makeDataSource];
	[self makeMaze];
	
}


#pragma mark - CollectionView methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.datasourceCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	TileCollectionViewCell *cell = (TileCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	
	// get row and column
	NSInteger row = indexPath.row / self.numberOfItemsAcross;
	NSInteger column = indexPath.row % self.numberOfItemsAcross;
	
	// get corresponding data item
	
	GameTile * gametile = self.datasource[row][column];
	cell.tileView.backgroundColor = gametile.isWall ? [UIColor lightGrayColor] : [UIColor whiteColor];
	
	if (gametile.isWall) {
		cell.tileView.backgroundColor = [UIColor lightGrayColor];
	}
	else {
		cell.tileView.backgroundColor = [UIColor whiteColor];
	}
	
	switch (gametile.type) {
		case pilot:
		case path:
			cell.tileView.backgroundColor = [UIColor blueColor];
			break;
		case startingPoint:
			cell.tileView.backgroundColor = [UIColor greenColor];
			break;
		case goal:
			cell.tileView.backgroundColor = [UIColor redColor];
			break;
		default:
			break;
			
	}
	if (gametile.isWall || gametile.score < 0) {
		cell.theLabel.hidden = YES;
	}
	else {
		cell.theLabel.hidden = NO;
		cell.theLabel.text = [NSString stringWithFormat:@"%li", gametile.score];
	}

	return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	[self makeDataSource];
	[self makeMaze];
	
}


- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat width = (self.view.frame.size.width - self.insetValue * 2) / self.numberOfItemsAcross;
	return CGSizeMake(width, width);
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	
	return UIEdgeInsetsMake(self.insetValue, self.insetValue, self.insetValue, self.insetValue);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	
	return 0;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	
	return 0;
}


#pragma mark - Path finding

- (void) makeMaze {
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

		BOOL northChecked = NO;
		BOOL westChecked = NO;
		BOOL southChecked = NO;
		BOOL eastChecked = NO;
		
		NSInteger totalTiles = 0;
		NSInteger tilesVisited = 1;
		
		NSMutableArray * undoStack = [NSMutableArray new];
		
		GameTile * previous = self.datasource[1][1];
		previous.visited = YES;
		[undoStack addObject:previous];
		
		for (NSMutableArray *row in self.datasource) {
			for (GameTile * tile in row) {
				if (!tile.isWall) {
					totalTiles ++;
				}
			}
		}
		
		while (1) {
			NSInteger currentDirection = arc4random_uniform(4);
			
			switch (currentDirection) {
				case north:
				{
					if (northChecked) {
						continue;
					}
					
					// check if two spaces north is available
					
					if (previous.row - 2 <= 0) {
						northChecked = YES;
					}
					else {
						
						NSInteger newRow = previous.row - 2;
						
						// get the corresponding tile
						GameTile * tile = self.datasource[newRow][previous.column];

						if (tile.visited == YES) {
							northChecked = YES;
						}
						else {
							northChecked = NO;
							southChecked = NO;
							westChecked = NO;
							eastChecked = NO;
							
							tilesVisited ++;
							// Get the wall, tear it down
							GameTile * wall = self.datasource[previous.row - 1][previous.column];
							wall.isWall = NO;
							// update tile
							tile.visited = YES;
							
							[wall.neighbors addObject: previous];
							[previous.neighbors addObject:wall];
							[tile.neighbors addObject: wall];
							[wall.neighbors addObject:tile];
							
							[undoStack insertObject: tile atIndex:0];
							previous.type = none;
							previous = tile;
							previous.type = pilot;
							
						}
					}
				}
					break;
				case east:
					
					if (eastChecked) {
						continue;
					}
					
					if (previous.column + 2 >= self.numberOfItemsAcross) {
						eastChecked = YES;
					}
					else {
						NSInteger newColumn = previous.column + 2;
						GameTile * tile = self.datasource[previous.row][newColumn];
						if (tile.visited) {
							eastChecked = YES;
						}
						else {
							northChecked = NO;
							southChecked = NO;
							westChecked = NO;
							eastChecked = NO;
							
							tilesVisited ++;
							// Get the wall, tear it down
							GameTile * wall = self.datasource[previous.row][previous.column + 1];
							wall.isWall = NO;
							// update tile
							tile.visited = YES;
							
							[wall.neighbors addObject: previous];
							[previous.neighbors addObject:wall];
							[tile.neighbors addObject: wall];
							[wall.neighbors addObject:tile];
							
							[undoStack insertObject: tile atIndex:0];
							previous.type = none;
							previous = tile;
							previous.type = pilot;
							
						}
					}
					break;
				case south:
				{
					if (southChecked) {
						continue;
					}
					// check if two spaces north is available
					
					if (previous.row + 2 >= self.datasource.count) {
						southChecked = YES;
					}
					else {
						NSInteger newRow = previous.row + 2;
						
						// get the corresponding tile
						GameTile * tile = self.datasource[newRow][previous.column];
						if (tile.visited == YES) {
							southChecked = YES;
						}
						else {
							northChecked = NO;
							southChecked = NO;
							westChecked = NO;
							eastChecked = NO;
						
							tilesVisited ++;
							// Get the wall, tear it down
							GameTile * wall = self.datasource[previous.row + 1][previous.column];
							wall.isWall = NO;
							// update tile
							tile.visited = YES;
							
							[wall.neighbors addObject: previous];
							[previous.neighbors addObject:wall];
							[tile.neighbors addObject: wall];
							[wall.neighbors addObject:tile];
							[undoStack insertObject: tile atIndex:0];
							previous.type = none;
							previous = tile;
							previous.type = pilot;
							
						}
					}
				}
					break;
				case west:
					
					if (westChecked) {
						continue;
					}
					
					if (previous.column - 2 <= 0) {
						westChecked = YES;
					}
					else {
						NSInteger newColumn = previous.column - 2;
						GameTile * tile = self.datasource[previous.row][newColumn];
						if (tile.visited) {
							westChecked = YES;
						}
						else {
							northChecked = NO;
							southChecked = NO;
							westChecked = NO;
							eastChecked = NO;
							
							tilesVisited ++;
							// Get the wall, tear it down
							GameTile * wall = self.datasource[previous.row][previous.column - 1];
							wall.isWall = NO;
							// update tile
							tile.visited = YES;
							
							[wall.neighbors addObject: previous];
							[previous.neighbors addObject:wall];
							[tile.neighbors addObject: wall];
							[wall.neighbors addObject:tile];
							
							[undoStack insertObject: tile atIndex:0];
							previous.type = none;
							previous = tile;
							previous.type = pilot;
							
						}
					}
					break;
			}
			
			if (northChecked && southChecked && eastChecked && westChecked) {

				[undoStack removeObjectAtIndex:0];
				previous.type = none;
				previous = undoStack[0];
				previous.type = pilot;
				northChecked = NO;
				southChecked = NO;
				westChecked = NO;
				eastChecked = NO;
			}
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				[self.collectionView reloadData];
			});
			
			if (tilesVisited >= totalTiles) {
				previous.type = none;
				break;
			}
		}
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self setMarkers];
		});
	});
}



- (void) setMarkers {
	
	// pick random row and column for start until you get an empty tile
	
	NSInteger randomRow = arc4random_uniform((int)self.datasource.count);
	NSInteger randomColumn = arc4random_uniform(self.numberOfItemsAcross);
	GameTile * tile = self.datasource[randomRow][randomColumn];
	
	while (tile.isWall) {
		randomRow = arc4random_uniform((int)self.datasource.count);
		randomColumn = arc4random_uniform(self.numberOfItemsAcross);
		tile = self.datasource[randomRow][randomColumn];
	}
	
	tile.type = startingPoint;
	self.startingPoint = tile;
	
	[self.collectionView reloadData];
	
	// pick random row and column for goal until you get an empty tile
	
	randomRow = arc4random_uniform((int)self.datasource.count);
	randomColumn = arc4random_uniform(self.numberOfItemsAcross);
	tile = self.datasource[randomRow][randomColumn];
	
	while (tile.isWall) {
		randomRow = arc4random_uniform((int)self.datasource.count);
		randomColumn = arc4random_uniform(self.numberOfItemsAcross);
		tile = self.datasource[randomRow][randomColumn];
	}
	
	tile.type = goal;
	self.goal = tile;
	
	
	[self.collectionView reloadData];
	[self findpath];
	
}


- (BOOL) isOutOfBoundsForRow: (NSInteger) row column: (NSInteger) column {
	
	if (row <= 0 ||
		column >= self.numberOfItemsAcross ||
		column <= 0 ||
		row >= self.datasource.count) {
		return YES;
	}
	else {
		return NO;
	}
	
}


- (void) findpath {
	
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSMutableArray * queue = [NSMutableArray new];
		self.startingPoint.score = 0;
		[queue addObject:self.startingPoint];

		
		while (queue.count) {
			GameTile * currentTile = queue[0];
			
			
			for (GameTile * neighbor in currentTile.neighbors) {
				
				if (neighbor.score < 0) {
					neighbor.score = currentTile.score + 1;
					[queue addObject:neighbor];
				}
			}
			
			[queue removeObjectAtIndex:0];
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				[self.collectionView reloadData];
			});
		}
		
		// now starting at the end point, rewind to stroke the path
		
		GameTile * currentTile = self.goal;
		
		while(currentTile != self.startingPoint){
			for (GameTile * neighbor in currentTile.neighbors) {
				if (neighbor.score < currentTile.score) {
					if (neighbor != self.startingPoint) {
						neighbor.type = path;
					}

					currentTile = neighbor;
				}
			}
		}
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self.collectionView reloadData];
		});
		
	});
	
}

- (void) makeDataSource {
	
	[self.datasource removeAllObjects];
	
	CGFloat widthOfItem = (self.view.frame.size.width - self.insetValue * 2) / self.numberOfItemsAcross;
	int availableHeight = (self.view.frame.size.height - (2 * self.insetValue));
	int numberOfItemsDeep	= availableHeight / widthOfItem;
	self.datasourceCount = numberOfItemsDeep * self.numberOfItemsAcross;
	
	for (int i = 0; i < numberOfItemsDeep;  i++) {
		NSMutableArray * array = [NSMutableArray new];
		for (int l = 0; l < self.numberOfItemsAcross; l++) {
			GameTile * tile = [GameTile new];
			tile.row = i;
			tile.column = l;
			if (i % 2 == 0 || l % 2 == 0) {
				tile.isWall = YES;
			}
			
			[array addObject:tile];
		}
		[self.datasource addObject:array];
	}
}

@end


@implementation GameTile


- (instancetype)init
{
	self = [super init];
	if (self) {
		self.isWall = NO;
		self.visited = NO;
		self.type = none;
		self.neighbors = [NSMutableArray new];
		self.score = -1;
	}
	return self;
}

@end

