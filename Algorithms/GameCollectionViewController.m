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
	self.numberOfItemsAcross = 39;
	
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
	
	NSInteger capacity = 9999;
	
	NSArray * names = [self makeArrayOfNamesWithCapacity:capacity];
	NSArray * dates = [self makeArrayOfDatesWithCapacity:capacity];
	NSMutableArray * people = [NSMutableArray new];
	
	for (int i = 0; i<capacity ; i++) {
		NSDate * date = dates[i];
		NSString * name = names[i];
		
		Person * person = [[Person alloc]initWithDate:date andName:name];
		[people addObject:person];
	}
	
//	[self doBinarySearch];
//	
//	[self compareSort:names];
//	[self sortDescriptorsSort:people];
//	[self compareSort2:people];
//	[self blockCompare:people];
//	[self locationSort:people];
//	[self insertionSort:people];
	
	/*
	
	NSInteger factorial = [self factorial:12];
	NSLog(@"I found the factorial to be: %li", factorial);
	
	NSInteger recursiveFactorial = [self recursiveFactorial:12];
	NSLog(@"I found the recursiveFactorial to be: %li", recursiveFactorial);
	
//	BOOL isPalindrome = [self isPalindrome:@"ababa"];
	if ([self isPalindrome:@"ababaababaababaababa"]) {
		NSLog(@"Found palindrome");
	}
	else {
		NSLog(@"Not a palindrome");
	}
	 */
	
	NSInteger result = [self calculate:9 toThePowerOf:6];
	NSLog(@"This is the result: %li", result);
	
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

- (void) findpath {
	
	// lets mark all the squares with a score until we reach the goal.
//	NSInteger row = self.goal.row;
//	NSInteger column = self.goal.column;
	
	// Now lets explore every possible path
	
	
	
}


#pragma mark - Binary Search


- (void) doBinarySearch {
	
	NSInteger random = arc4random_uniform(100000);
	
	NSMutableArray * array = [NSMutableArray new];
	
	for (int i = 0; i<random; i++) {
		[array addObject:@(i)];
	}
	
	NSLog(@"What is the random: %li and the array count: %li", random, array.count);
	
	NSInteger target = arc4random_uniform((int)array.count);
	
	NSInteger min = 0;
	NSInteger max = array.count - 1;
	
	while (1) {
		NSInteger middle = (max + min) / 2;
		NSInteger guess = ((NSNumber *)array[middle]).intValue;
		
		NSLog(@"guess: %li, target: %li, min: %li, max: %li", guess, target, min, max);
		
		if (guess == target) {
			NSLog(@"Found it! Breaking");
			break;
		}
		else if (guess > target){
			max = guess - 1;
		}
		else {
			min = guess + 1;
		}
	}
}

#pragma mark - Sort

// First method (using compare:)
- (void) compareSort: (NSArray *) array {
	
	NSDate * start = [NSDate date];
	
	NSArray * sortedArray __attribute__((unused)) = [array sortedArrayUsingSelector:@selector(compare:)];
	
	NSDate * end = [NSDate date];
	NSTimeInterval duration = [end timeIntervalSinceDate:start];
	NSLog(@"compareSort: completed in %f", duration);
}

// Second method (using sort descriptors)
- (void) sortDescriptorsSort: (NSArray *) array {
	
	NSDate * start = [NSDate date];
	
	NSSortDescriptor * descriptors = [[NSSortDescriptor alloc]initWithKey:@"birthDate" ascending:YES];
	NSArray * sortedArray __attribute__((unused)) = [array sortedArrayUsingDescriptors:@[descriptors]];
	
	NSDate * end = [NSDate date];
	NSTimeInterval duration = [end timeIntervalSinceDate:start];
	NSLog(@"sortDescriptorsSort: completed in %f", duration);
	
	//	for (Person * person in sortedArray) {
	//		NSLog(@"this is the date: %@", person.birthDate);
	//	}
}

// Third method (implementing compare)
- (void) compareSort2: (NSArray *) array {
	
	NSDate * start = [NSDate date];
	
	NSArray * sortedArray __attribute__((unused)) = [array sortedArrayUsingSelector:@selector(compare:)];
	
	NSDate * end = [NSDate date];
	NSTimeInterval duration = [end timeIntervalSinceDate:start];
	NSLog(@"compareSort2: completed in %f", duration);
	
	
	//	for (Person * person in sortedArray) {
	//		NSLog(@"this is the date: %@", person.birthDate);
	//	}
}

// Fourth method (using a block)
- (void) blockCompare: (NSArray *) array {
	
	NSDate * start = [NSDate date];
	
	NSArray * sortedArray __attribute__((unused)) = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		
		Person * person1 = (Person *) obj1;
		Person * person2 = (Person *) obj2;
		
		return [person1 compare: person2];
	}];
	
	NSDate * end = [NSDate date];
	NSTimeInterval duration = [end timeIntervalSinceDate:start];
	NSLog(@"blockCompare: completed in %f", duration);
	
	//	for (Person * person in sortedArray) {
	//		NSLog(@"this is the date: %@", person.birthDate);
	//	}
}

// Location sort
- (void) locationSort: (NSMutableArray *) array {
	
	NSDate * start = [NSDate date];
	
	//	NSLog(@"Coming in with array count: %i", array4.count);
	for (int i = 0; i<array.count; i++) {
		//		NSLog(@"Iterating with index: %li", i);
		NSInteger indexOfSmallest = [self indexOfSmallestWithStartingIndex:i andArray: array];
		Person * oldest = array[indexOfSmallest];
		[array removeObjectAtIndex:indexOfSmallest];
		[array insertObject:oldest atIndex:i];
	}
	
	NSDate * end = [NSDate date];
	NSTimeInterval duration = [end timeIntervalSinceDate:start];
	NSLog(@"locationSort: completed in %f", duration);
	
//	for (Person * person in array) {
//		NSLog(@"LOCATION: print person with date: %@", person.birthDate);
//	}
}


- (NSInteger) indexOfSmallestWithStartingIndex: (NSInteger) index andArray: (NSMutableArray *) array {
	
	NSDate * smallestDate = ((Person *)array[index]).birthDate;
	NSInteger indexOfSmallest = index;
	
	//	NSLog(@"What is the array count: %i", array.count);
	
	for (NSInteger i = index + 1; i < array.count; i++) {
		//		NSLog(@"Iterating2 with index: %i", i);
		Person * person = array[i];
		//		NSLog(@"Comparing birthdate: %@ with reference: %@", person.birthDate, smallestDate);
		if ([person.birthDate compare:smallestDate] == NSOrderedAscending) {
			//			NSLog(@"Test passed!, returning index: %i", i);
			smallestDate = person.birthDate;
			indexOfSmallest = i;
		}
	}
	
	return indexOfSmallest;
}

// Insertion sort
- (void) insertionSort: (NSMutableArray *) array {
	
	NSDate * start = [NSDate date];
	
	for (NSInteger i = 1; i < array.count; i++) {
//		NSLog(@"iterating1 with i: %li", i);
		Person * person = (Person *)array[i];
		NSInteger insert = [self slideFromIndex:i-1 array:array value:person.birthDate];
		array[insert] = person;
	}
	
	NSDate * end = [NSDate date];
	NSTimeInterval duration = [end timeIntervalSinceDate:start];
	NSLog(@"insertionSort: completed in %f", duration);
	
//	for (Person * person in array) {
//		NSLog(@"INSERTION: print person with date: %@", person.birthDate);
//	}
}


- (NSInteger) slideFromIndex: (NSInteger) index array: (NSMutableArray *) array value: (NSDate *) date {
	
	NSInteger insertIndex = index;
//	NSLog(@"Coming in with index: %li", index);
	
	for (NSUInteger i = index; [((Person *)array[i]).birthDate compare:date] == NSOrderedDescending; i--) {
//		NSLog(@"Iterating with index: %li", i);
		array[i+1] = array[i];
		insertIndex = i;
		
		if (i==0) {
			break;
		}
	}
	
	return insertIndex;
}

#pragma mark - Recursion

- (NSInteger) factorial: (NSInteger) value {
	NSInteger result = 1;
	
	for (NSInteger i = 1; i <= value; i++) {
		result = result * i;
		NSLog(@"Iterating with result: %li", result);
	}
	
	return result;
}

- (NSInteger) recursiveFactorial: (NSInteger) n {
	
	if (n == 0) {
		return 1;
	}

	return n * ([self recursiveFactorial:(n -1)]);
}


- (BOOL) isPalindrome: (NSString *) string {
	
	if (string.length <= 1) {
		return YES;
	}
	
	NSString * firstLetter = [string substringToIndex:1];
	NSString * lastLetter = [string substringFromIndex:string.length - 1];
	
	NSLog(@"Comparing first letter: %@ and last letter: %@", firstLetter, lastLetter);
	
	if ([firstLetter isEqualToString:lastLetter]) {
		NSString * substring = [string substringWithRange:NSMakeRange(1, string.length -2)];
		NSLog(@"Checking substring: %@", substring);
		return [self isPalindrome: substring];
	}
	else {
		return NO;
	}
}


- (NSInteger) calculate: (NSInteger) value toThePowerOf: (NSInteger) power {
	
	if (power == 0) {
		return 1;
	}
	
	if (power > 0) {
		if ([self isEven:power]) {
			return [self calculate:value toThePowerOf:power/2] * [self calculate:value toThePowerOf:power/2];
		}
		else {
			return value * [self calculate:value toThePowerOf:power - 1];
		}
	}
	else {
		return 1 / [self calculate:value toThePowerOf:- power];
	}
}

- (BOOL) isEven: (NSInteger) value {
	
	return (value % 2 == 0);
}


#pragma mark - Helpers

- (NSArray *) makeArrayOfNamesWithCapacity: (NSInteger) capacity {
	
	NSArray * names = @[@"Kevin",
						@"John",
						@"Amy",
						@"Britney",
						@"Marc",
						@"Joseph",
						@"Mike",
						@"Dan",
						@"Dave",
						@"Eric",
						@"Ann",
						@"Mary"];
	
	NSInteger random = arc4random_uniform(12);
	
	NSMutableArray * returnArray = [@[]mutableCopy];
	
	for (NSInteger i = 0; i < capacity; i++){
		[returnArray addObject:names [random]];
	}
	
	return [returnArray copy];
	
}

- (NSArray *) makeArrayOfDatesWithCapacity: (NSInteger) capacity {
	
	NSMutableArray * dates = [NSMutableArray new];
	
	int yearUpperBound = 2017;
	int yearLowerBound = 1900;
	
	for (NSInteger i = 0; i<capacity ; i++) {
		NSDateComponents * components = [[NSDateComponents alloc]init];
		components.day = arc4random_uniform(28);
		components.month = arc4random_uniform(13);
		components.year = yearLowerBound + arc4random() % (yearUpperBound - yearLowerBound);;
		
		NSDate * birthdate = [[NSCalendar currentCalendar] dateFromComponents:components];
		[dates addObject:birthdate];
		
	}
	
	return [dates copy];
	
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

@implementation Person

- (instancetype)initWithDate: (NSDate *) date andName: (NSString *) name
{
	self = [super init];
	if (self) {
		self.birthDate = date;
		self.firstName = name;
	}
	return self;
}

- (NSComparisonResult)compare:(id)other
{
	
	if ([self.birthDate compare: ((Person *)other).birthDate] == NSOrderedDescending) {
		return NSOrderedDescending;
	}
	else if ([self.birthDate compare: ((Person *)other).birthDate] == NSOrderedAscending) {
		return NSOrderedAscending;
	}
	else {
		return NSOrderedSame;
	}
}


@end
