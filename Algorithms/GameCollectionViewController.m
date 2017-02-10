//
//  GameCollectionViewController.m
//  Algorithms
//
//  Created by Maxime Boulat on 2/3/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import "GameCollectionViewController.h"
#import "TileCollectionViewCell.h"
#import "AlgorithmManager.h"

@interface GameCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGFloat insetValue;
@property (nonatomic, assign) int numberOfItemsAcross;
@property (nonatomic, assign) int datasourceCount;

@property (nonatomic, retain) NSMutableArray <NSMutableArray *> * datasource;

@property (nonatomic, retain) GameTile * startingPoint;
@property (nonatomic, retain) GameTile * goal;

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
	self.numberOfItemsAcross = 37;
	
	CGFloat widthOfItem = (self.view.frame.size.width - self.insetValue * 2) / self.numberOfItemsAcross;
	int availableHeight = (self.view.frame.size.height - (2 * self.insetValue));
	int numberOfItemsDeep	= availableHeight / widthOfItem;
	self.datasourceCount = numberOfItemsDeep * self.numberOfItemsAcross;
	
	self.datasource = [NSMutableArray new];
	
	for (int i = 0; i < numberOfItemsDeep;  i++) {
		NSMutableArray * array = [NSMutableArray new];
		for (int l = 0; l < self.numberOfItemsAcross; l++) {
			GameTile * tile = [GameTile new];
			tile.row = i;
			tile.column = l;
			if (i % 2 == 0 || l % 2 == 0) {
				tile.isWall = YES;
			}
			
			//			int r = arc4random_uniform(2);
			
			[array addObject:tile];
		}
		[self.datasource addObject:array];
	}
	
	//	[self makeMaze];
	[self breadthFirstMaze];
	
	NSInteger capacity = 3000;
	
	NSArray * names = [AlgorithmManager makeArrayOfNamesWithCapacity:capacity];
	NSArray * dates = [AlgorithmManager makeArrayOfDatesWithCapacity:capacity];
	NSMutableArray * people = [NSMutableArray new];
	
	for (int i = 0; i<capacity ; i++) {
		NSDate * date = dates[i];
		NSString * name = names[i];
		
		Person * person = [[Person alloc]initWithDate:date andName:name];
		[people addObject:person];
	}
	
	//	[AlgorithmManager doBinarySearch];
	//
	//	[AlgorithmManager compareSort:names];
	//	[AlgorithmManager sortDescriptorsSort:people];
	//	[AlgorithmManager compareSort2:people];
	//	[AlgorithmManager blockCompare:people];
	//	[AlgorithmManager locationSort:people];
	//	[AlgorithmManager insertionSort:people];
	
	/*
	 
	 NSInteger factorial = [AlgorithmManager factorial:12];
	 NSLog(@"I found the factorial to be: %li", factorial);
	 
	 NSInteger recursiveFactorial = [AlgorithmManager recursiveFactorial:12];
	 NSLog(@"I found the recursiveFactorial to be: %li", recursiveFactorial);
	 
	 //	BOOL isPalindrome = [AlgorithmManager isPalindrome:@"ababa"];
	 if ([self isPalindrome:@"ababaababaababaababa"]) {
		NSLog(@"Found palindrome");
	 }
	 else {
		NSLog(@"Not a palindrome");
	 }
	 */
	
	//	NSInteger result = [AlgorithmManager calculate:9 toThePowerOf:6];
	//	NSLog(@"This is the result: %li", result);
	
	/*
	 NSDate * start = [NSDate date];
	 NSArray * sorted = [AlgorithmManager mergeSort:people];
	 
	 NSDate * end = [NSDate date];
	 NSTimeInterval duration = [end timeIntervalSinceDate:start];
	 NSLog(@"mergeSort: completed in %f", duration);
	 
	 
	 
	 start = [NSDate date];
	 [AlgorithmManager doQuickSort:people startIndex:0 endIndex:people.count - 1];
	 
	 end = [NSDate date];
	 duration = [end timeIntervalSinceDate:start];
	 NSLog(@"quicksort: completed in %f", duration);
	 
	 */
	
	
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
		default:
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


#pragma mark - Path finding

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
							
							[undoStack insertObject:self.datasource[currentRow][currentColumn] atIndex:0];
							
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
							
							[undoStack insertObject:self.datasource[currentRow][currentColumn] atIndex:0];
							
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
							
							[undoStack insertObject:self.datasource[currentRow][currentColumn] atIndex:0];
							
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
							
							[undoStack insertObject:self.datasource[currentRow][currentColumn] atIndex:0];
							
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
				
				GameTile * previous = undoStack[0];
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
			
			//			[NSThread sleepForTimeInterval:0.5];
			
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
	
}

- (void) breadthFirstMaze {
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSMutableArray * queue = [@[]mutableCopy];
		[queue addObject:self.datasource [1][1]];
		
		while (queue.count) {
			
			NSLog(@"Coming in the queue with queue count: %lu", (unsigned long)queue.count);
			//
			//			for (NSInteger i = 0; i < queue.count; i++) {
			GameTile * currentTile = queue[0];
			
			// Get the adjacent tiles
			
			
			// north
			NSInteger row = currentTile.row + 2;
			
			NSLog(@"Checking row: %li and column: %li", row, currentTile.column);
			
			if (![self isOutOfBoundsForRow:row column:currentTile.column]) {
				NSLog(@"Not out of bounds");
				
				GameTile * incoming = self.datasource[row][currentTile.column];
				
				
				if (!incoming.ancestor) {
					NSLog(@"Not visited");
					[queue addObject:incoming];
					GameTile * divider = self.datasource[currentTile.row + 1][currentTile.column];
					divider.isWall = NO;
					incoming.ancestor = currentTile;
				}
				else {
					NSLog(@"Visited");
				}
			}
			else {
				NSLog(@"Out of bounds");
			}
			
			// east
			NSInteger column = currentTile.column + 2;
			
			NSLog(@"Checking row: %li and column: %li", currentTile.row, column);
			if (![self isOutOfBoundsForRow:currentTile.row column:column]) {
				NSLog(@"Not out of bounds");
				GameTile * incoming = self.datasource[currentTile.row][column];
				
				if (!incoming.ancestor) {
					NSLog(@"Not visited");
					[queue addObject:incoming];
					GameTile * divider = self.datasource[currentTile.row][currentTile.column + 1];
					divider.isWall = NO;
					incoming.ancestor = currentTile;
				}
				else {
					NSLog(@"Visited");
				}
			}
			else {
				NSLog(@"Out of bounds");
			}
			
			// south
			row = currentTile.row + 2;
			NSLog(@"Checking row: %li and column: %li", row, currentTile.column);
			if (![self isOutOfBoundsForRow:row column:currentTile.column]) {
				NSLog(@"Not out of bounds");
				GameTile * incoming = self.datasource[row][currentTile.column];
				
				if (!incoming.ancestor) {
					NSLog(@"Not visited");
					[queue addObject:incoming];
					GameTile * divider = self.datasource[currentTile.row - 1][currentTile.column];
					divider.isWall = NO;
					incoming.ancestor = currentTile;
				}
				else {
					NSLog(@"Visited");
				}
			}
			else {
				NSLog(@"Out of bounds");
			}
			
			// west
			column = currentTile.column - 2;
			NSLog(@"Checking row: %li and column: %li", currentTile.row, column);
			if (![self isOutOfBoundsForRow:currentTile.row column:column]) {
				NSLog(@"Not out of bounds");
				GameTile * incoming = self.datasource[currentTile.row][column];
				
				if (!incoming.ancestor) {
					NSLog(@"Not visited");
					[queue addObject:incoming];
					GameTile * divider = self.datasource[currentTile.row][currentTile.column - 1];
					divider.isWall = NO;
					incoming.ancestor = currentTile;
				}
				else {
					NSLog(@"Visited");
				}
			}
			else {
				NSLog(@"Out of bounds");
			}
			
			[queue removeObjectAtIndex:0];
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				[self.collectionView reloadData];
			});
			
		}
		
		
		NSLog(@"EXITING the queue!!!!!");
		
	});
	
}


- (BOOL) isOutOfBoundsForRow: (NSInteger) row column: (NSInteger) column {
	
	if (row <= 0 ||
		column >= self.numberOfItemsAcross ||
		column <= 0 ||
		row >= self.datasource.count) {
		return YES;
	}
	
	return NO;
}


- (void) findpath {
	
	// lets mark all the squares with a score until we reach the goal.
	//	NSInteger row = self.goal.row;
	//	NSInteger column = self.goal.column;
	
	// Now lets explore every possible path
	
	
	
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

