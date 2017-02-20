//
//  AlgorithmsTests.m
//  AlgorithmsTests
//
//  Created by Maxime Boulat on 2/18/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AlgorithmManager.h"

@interface AlgorithmsTests : XCTestCase

@property (nonatomic, strong) NSArray * numbers;

@end

@implementation AlgorithmsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	
	self.numbers = [AlgorithmManager makeArrayOfIntsWithCapacity:525 range:100];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Tests


- (void) testPushZeroes {
	
	NSMutableArray * shifted = [self.numbers mutableCopy];
	[AlgorithmManager pushZeroes: shifted];
	
	BOOL passed = YES;
	
	if (shifted.count != self.numbers.count) {
		passed = NO;
	}
	
	BOOL rangeStarted = NO;
	
	for (NSInteger i = 0; i < shifted.count; i++) {
		
		NSNumber * number = shifted [i];
		
		if (!rangeStarted) {
			if (number.integerValue == 0) {
				rangeStarted = YES;
			}
		}
		else if (number.integerValue != 0){
			passed = NO;
		}
		
		if (rangeStarted && i == shifted.count - 1 && number.integerValue != 0) {
			passed = NO;
		}
	}
	
	XCTAssertTrue(passed);
	
}

- (void) testPullZeroes {
	
	NSMutableArray * shifted = [self.numbers mutableCopy];
	[AlgorithmManager pullZeroes: shifted];
	
	BOOL passed = YES;
	
	if (shifted.count != self.numbers.count) {
		passed = NO;
	}
	
	BOOL rangeStarted = NO;
	
	for (NSInteger i = shifted.count - 1; i >= 0; i--) {
		NSNumber * number = shifted [i];
		
		if (!rangeStarted) {
			if (number.integerValue == 0) {
				rangeStarted = YES;
			}
		}
		else if (number.integerValue != 0){
			passed = NO;
		}
		
		if (rangeStarted && i == 0 && number.integerValue != 0) {
			passed = NO;
		}
	}
	
	XCTAssertTrue(passed);
	
}

- (void) testRemoveDuplicates {
	
	NSMutableArray * result = [self.numbers mutableCopy];
	[AlgorithmManager removeDuplicates: result];
	
	NSCountedSet * bag = [NSCountedSet new];
	[bag addObjectsFromArray: self.numbers];

	NSArray * g = [[bag allObjects] sortedArrayUsingSelector:@selector(compare:)];
	
	
	XCTAssertEqualObjects([result sortedArrayUsingSelector:@selector(compare:)], g);
}

- (void) testLocationSort {
	
	NSMutableArray * sorted = [self.numbers mutableCopy];
	[AlgorithmManager locationSort: sorted];
	
	NSArray * g = [self.numbers sortedArrayUsingSelector:@selector(compare:)];
	
	XCTAssertEqualObjects(sorted, g);
}

- (void) testInsertionSort {
	
	NSMutableArray * sorted = [self.numbers mutableCopy];
	[AlgorithmManager insertionSort: sorted];
	
	NSArray * g = [self.numbers sortedArrayUsingSelector:@selector(compare:)];
	
	XCTAssertEqualObjects(sorted, g);
	
}

- (void) testMergeSort {
	
	NSMutableArray * sorted = [self.numbers mutableCopy];
	[AlgorithmManager mergeSort: sorted start: 0 end:self.numbers.count - 1];
	
	NSArray * g = [self.numbers sortedArrayUsingSelector:@selector(compare:)];
	
	XCTAssertEqualObjects(sorted, g);
}

- (void) testQuickSort {
	
	NSMutableArray * sorted = [self.numbers mutableCopy];
	[AlgorithmManager quickSort:sorted startIndex: 0 endIndex: sorted.count - 1];
	
	NSArray * g = [self.numbers sortedArrayUsingSelector:@selector(compare:)];
	
	XCTAssertEqualObjects(sorted, g);
}

- (void) testPalindrome {
	
	NSString * palindrome = @"rotor";
	NSString * notAPalindrome = @"aefcsajbcweajcbqk";
	
	XCTAssertTrue([AlgorithmManager isPalindrome: palindrome]);
	XCTAssertFalse([AlgorithmManager isPalindrome: notAPalindrome]);
}

- (void) testBinaryTreeToList {
	
	BinaryTree * binaryTree = [BinaryTree new];
	
	for (NSNumber * number in self.numbers) {
		[binaryTree insertValue:number];
	}
	
	NSArray * list = [AlgorithmManager binaryTreeToList:binaryTree];
	
	NSArray * g = [self.numbers sortedArrayUsingSelector:@selector(compare:)];
	
	XCTAssertEqualObjects(list, g);
}

- (void) testPermutations {
	
	NSArray * input = @[@2, @3, @4];
	
	NSDictionary * map = @{@2 : @[@"A", @"B", @"C"],
						   @3 : @[@"D", @"E", @"F"],
						   @4 : @[@"G", @"H", @"I"],
								 @5 : @[@"J", @"K", @"L"],
						   @6 : @[@"M", @"N", @"O"],
						   @7 : @[@"P", @"Q", @"R", @"S"],
								 @8 : @[@"T", @"U", @"V"]};
	
	NSArray * result = [AlgorithmManager setupPermutationsWithInput: input andMap: map];
	
	NSArray * g = @[@"ADG", @"ADH", @"ADI", @"AEG", @"AEH", @"AEI", @"AFG", @"AFH", @"AFI", @"BDG", @"BDH", @"BDI", @"BEG", @"BEH", @"BEI", @"BFG", @"BFH", @"BFI", @"CDG", @"CDH", @"CDI", @"CEG", @"CEH", @"CEI", @"CFG", @"CFH", @"CFI"];
	
	XCTAssertEqualObjects([result sortedArrayUsingSelector:@selector(compare:)], [g sortedArrayUsingSelector:@selector(compare:)]);
	
}

- (void) testSwapNodes {
	
	LinkedList * linkedList = [LinkedList new];
	for (NSNumber * number in self.numbers) {
		[linkedList insertValue:number];
	}
	
	[linkedList swapNodes];
	
	NSMutableArray * swapped = [NSMutableArray new];
	
	LinkedListItem * currentItem = linkedList.head;
	
	while (currentItem) {
		[swapped addObject:currentItem.value];
		currentItem = currentItem.nextItem;
	}
	
	NSMutableArray *g = [self.numbers mutableCopy];
	
	for (NSInteger i = 0; i < g.count; i = i + 2) {
		if (i + 1 < g.count) {
			NSNumber * first = g[i];
			NSNumber * second = g[i + 1];
			g[i + 1] = first;
			g[i] = second;
		}
	}
	
	XCTAssertEqualObjects(swapped, g);
}

- (void) testEnumerator {
	
	NSArray * array = @[@[@[@3, @45, @4, @[@2, @89, @7], @4, @1], @7, @[@35, @2], @6], @15, @97];
	
	Enumerator * enumerator = [[Enumerator alloc]initWithData:array];
	
	XCTAssertEqual([enumerator next].integerValue, 3);
	XCTAssertEqual([enumerator next].integerValue, 45);
	XCTAssertEqual([enumerator next].integerValue, 4);
	XCTAssertEqual([enumerator next].integerValue, 2);
	XCTAssertEqual([enumerator next].integerValue, 89);
	XCTAssertEqual([enumerator next].integerValue, 7);
	XCTAssertEqual([enumerator next].integerValue, 4);
	XCTAssertEqual([enumerator next].integerValue, 1);
	XCTAssertEqual([enumerator next].integerValue, 7);
	XCTAssertEqual([enumerator next].integerValue, 35);
	XCTAssertEqual([enumerator next].integerValue, 2);
	XCTAssertEqual([enumerator next].integerValue, 6);
	XCTAssertEqual([enumerator next].integerValue, 15);
	XCTAssertEqual([enumerator next].integerValue, 97);
	
	NSArray * g = @[@3, @45, @4, @2, @89, @7, @4, @1, @7, @35, @2, @6, @15, @97];
	
	XCTAssertEqualObjects([enumerator allObjects], g);
}



- (void)testSortPerformance {
	// This is an example of a performance test case.
	[self measureBlock:^{
		[self.numbers sortedArrayUsingSelector:@selector(compare:)];
	}];
}

- (void)testLocationSortPerformance {
	// This is an example of a performance test case.
	[self measureBlock:^{
		[AlgorithmManager locationSort: [self.numbers mutableCopy]];
	}];
}

- (void)testInsertionSortPerformance {
	// This is an example of a performance test case.
	[self measureBlock:^{
		[AlgorithmManager insertionSort: [self.numbers mutableCopy]];
	}];
}

- (void)testMergeSortPerformance {
	// This is an example of a performance test case.
	[self measureBlock:^{
		[AlgorithmManager mergeSort: [self.numbers mutableCopy]  start: 0 end:self.numbers.count - 1];
	}];
}

- (void)testQuickSortPerformance {
	// This is an example of a performance test case.
	[self measureBlock:^{
		[AlgorithmManager quickSort:[self.numbers mutableCopy] startIndex: 0 endIndex: self.numbers.count - 1];
	}];
}


@end
