//
//  GameCollectionViewController.m
//  Algorithms
//
//  Created by Maxime Boulat on 2/3/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import "GameCollectionViewController.h"
#import "TileCollectionViewCell.h"

@interface GameCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGFloat insetValue;
@property (nonatomic, assign) int numberOfItemsAcross;
@property (nonatomic, assign) int datasourceCount;

@property (nonatomic, retain) NSMutableArray <NSMutableArray *> * datasource;

@end


typedef NS_ENUM(NSInteger, Direction) {
	north = 0,
	south,
	east,
	west
};


@implementation GameCollectionViewController 

static NSString * const reuseIdentifier = @"Cell";


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.insetValue = 15;
	self.numberOfItemsAcross = 35;
	
	CGFloat widthOfItem = (self.view.frame.size.width - self.insetValue * 2) / self.numberOfItemsAcross;
	int availableHeight = (self.view.frame.size.height - (2 * self.insetValue));
	int numberOfItemsDeep	= availableHeight / widthOfItem;
	self.datasourceCount = numberOfItemsDeep * self.numberOfItemsAcross;
	
	self.datasource = [NSMutableArray new];
	
	for (int i = 0; i < numberOfItemsDeep;  i++) {
		NSMutableArray * array = [NSMutableArray new];
		for (int l = 0; l < self.numberOfItemsAcross; l++) {
			GameTile * tile = [GameTile new];
			
			if (i % 2 == 0 || l % 2 == 0) {
				tile.isWall = YES;
			}
			
//			int r = arc4random_uniform(2);
			
			[array addObject:tile];
		}
		[self.datasource addObject:array];
	}
	
	[self makeMaze];

}

#pragma mark CollectionView methods

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
			cell.tileView.backgroundColor = [UIColor blueColor];
			break;
		case startingPoint:
			cell.tileView.backgroundColor = [UIColor greenColor];
			break;
		case goal:
			cell.tileView.backgroundColor = [UIColor redColor];
			break;
			
	}
	
	
	return cell;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/


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


#pragma mark Helper methods

- (void) makeMaze {
	

	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSInteger currentRow = 1;
		NSInteger currentColumn = 1;
		
		BOOL northChecked = NO;
		BOOL westChecked = NO;
		BOOL southChecked = NO;
		BOOL eastChecked = NO;
		
		NSInteger totalTiles = 0;
		NSInteger tilesVisited = 0;
		
		NSMutableArray * undoStack = [NSMutableArray new];
		
		GameTile * previous;
		
		for (NSMutableArray *column in self.datasource) {
			for (GameTile * tile in column) {
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
					NSLog(@"Going north");
					// check if two spaces north is available
					
					if (currentRow - 2 <= 0) {
						northChecked = YES;
						NSLog(@"North: Bailing because out of bounds");
					}
					else {
						
						NSInteger newRow = currentRow - 2;
						
						// get the corresponding tile
						GameTile * tile = self.datasource[newRow][currentColumn];
						tile.type = pilot;
						previous.type = none;
						previous = tile;
						if (tile.visited == YES) {
							NSLog(@"North: Bailing because already visited");
							northChecked = YES;
						}
						else {
							
							Coordinate * current = [Coordinate new];
							current.row = currentRow;
							current.column = currentColumn;
							[undoStack insertObject:current atIndex:0];
							
							NSLog(@"North: Updating");
							tilesVisited ++;
							// Get the wall, tear it down
							GameTile * wall = self.datasource[currentRow - 1][currentColumn];
							wall.isWall = NO;
							// update tile
							tile.visited = YES;
							currentRow = newRow;
							northChecked = NO;
						}
					}
				}
					break;
				case east:
					
					if (currentColumn + 2 >= self.numberOfItemsAcross) {
						NSLog(@"East: Bailing because out of bounds");
						eastChecked = YES;
					}
					else {
						NSInteger newColumn = currentColumn + 2;
						GameTile * tile = self.datasource[currentRow][newColumn];
						tile.type = pilot;
						previous.type = none;
						previous = tile;
						if (tile.visited) {
							NSLog(@"East: Bailing because already visited");
							eastChecked = YES;
						}
						else {
							
							Coordinate * current = [Coordinate new];
							current.row = currentRow;
							current.column = currentColumn;
							[undoStack insertObject:current atIndex:0];
							
							NSLog(@"East: Updating");
							tilesVisited ++;
							// Get the wall, tear it down
							GameTile * wall = self.datasource[currentRow][currentColumn + 1];
							wall.isWall = NO;
							// update tile
							tile.visited = YES;
							currentColumn = newColumn;
							eastChecked = NO;
						}
					}
					break;
				case south:
				{
					// check if two spaces north is available
					
					if (currentRow + 2 >= self.datasource.count) {
						NSLog(@"South: Bailing because out of bounds");
						southChecked = YES;
					}
					else {
						NSInteger newRow = currentRow + 2;
						
						// get the corresponding tile
						GameTile * tile = self.datasource[newRow][currentColumn];
						tile.type = pilot;
						previous.type = none;
						previous = tile;
						if (tile.visited == YES) {
							NSLog(@"South: Bailing because already visited");
							southChecked = YES;
						}
						else {
							
							Coordinate * current = [Coordinate new];
							current.row = currentRow;
							current.column = currentColumn;
							[undoStack insertObject:current atIndex:0];
							
							NSLog(@"South: Updating");
							tilesVisited ++;
							// Get the wall, tear it down
							GameTile * wall = self.datasource[currentRow + 1][currentColumn];
							wall.isWall = NO;
							// update tile
							tile.visited = YES;
							currentRow = newRow;
							southChecked = NO;
						}
					}
				}
					break;
				case west:
					if (currentColumn - 2 <= 0) {
						NSLog(@"West: Bailing because out of bounds");
						westChecked = YES;
					}
					else {
						NSInteger newColumn = currentColumn - 2;
						GameTile * tile = self.datasource[currentRow][newColumn];
						tile.type = pilot;
						previous.type = none;
						previous = tile;
						if (tile.visited) {
							NSLog(@"West: Bailing because already visited");
							westChecked = YES;
						}
						else {
							
							Coordinate * current = [Coordinate new];
							current.row = currentRow;
							current.column = currentColumn;
							[undoStack insertObject:current atIndex:0];
							
							NSLog(@"West: Updating");
							tilesVisited ++;
							// Get the wall, tear it down
							GameTile * wall = self.datasource[currentRow][currentColumn - 1];
							wall.isWall = NO;
							// update tile
							tile.visited = YES;
							currentColumn = newColumn;
							westChecked = NO;
						}
					}
					break;
			}
			
			NSLog(@"Tiles visited = %li totalTiles = %li", (long) tilesVisited, (long) totalTiles);
			
			if (northChecked && southChecked && eastChecked && westChecked) {
				
				NSLog(@"Dead end, backing out with %li", (long) undoStack.count);
				
				Coordinate * previous = undoStack[0];
				[undoStack removeObjectAtIndex:0];
				currentColumn = previous.column;
				currentRow = previous.row;
				northChecked = NO;
				southChecked = NO;
				westChecked = NO;
				eastChecked = NO;
			}
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				[self.collectionView reloadData];
			});
			
//			[NSThread sleepForTimeInterval:0.1];
			
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
	[self.collectionView reloadData];
	
}

- (void) findpath {
	
	
	
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
	}
	return self;
}

@end

@implementation Coordinate




@end
