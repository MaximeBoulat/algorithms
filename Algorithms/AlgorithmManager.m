//
//  AlgorithmManager.m
//  Algorithms
//
//  Created by Maxime Boulat on 2/10/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import "AlgorithmManager.h"



@implementation AlgorithmManager

#pragma mark - Binary Search

+ (void) doBinarySearch {
	
	NSInteger random = arc4random_uniform(100000);
	
	NSMutableArray * array = [NSMutableArray new];
	
	for (int i = 0; i<random; i++) {
		[array addObject:@(i)];
	}
	
	NSInteger target = arc4random_uniform((int)array.count);
	
	NSInteger min = 0;
	NSInteger max = array.count - 1;
	
	while (1) {
		NSInteger middle = (max + min) / 2;
		NSInteger guess = ((NSNumber *)array[middle]).intValue;
		
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

#pragma mark - Shift zeroes

+ (void) pushZeroes: (NSMutableArray *) array {
	
	NSInteger length = 0;
	
	for (NSInteger i = array.count - 1 ; i >= 0; i--) {
		
		NSNumber * value = array[i];
		
		if (value.intValue == 0) {
			length += 1;
		}
		else if (length != 0) {
			NSRange range = NSMakeRange(i + 1, length);
			NSArray * zeroes = [array subarrayWithRange:range];
			[array removeObjectsInRange:range];
			[array addObjectsFromArray:zeroes];
			length = 0;
		}
	}
	
	NSLog(@"Array after adjustment: %@", array);
}

+ (void) pullZeroes: (NSMutableArray *) array {
	
	NSInteger length = 0;
	
	for (NSInteger i = 0; i < array.count; i++) {
		
		NSNumber * value = array[i];
		if (value.intValue == 0) {
			length += 1;
		}
		else if (length != 0) {
			NSRange range = NSMakeRange(i - length, length);
			NSArray * zeroes = [array subarrayWithRange:range];
			NSLog(@"Found some zeroes: %@", zeroes);
			[array removeObjectsInRange:range];
			
			[array insertObjects:zeroes atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, length)]];
			length = 0;
			
		}
	}
	NSLog(@"Array after adjustment: %@", array);
	
}

#pragma mark - Remove duplicates

+ (void) removeDuplicates: (NSMutableArray *) array {
	
	NSCountedSet * bag = [NSCountedSet new];
	
	NSInteger i = 0;
	while (i < array.count) {
		NSNumber * value = array[i];
		if ([bag countForObject:value]) {
			[array removeObjectAtIndex:i];
		}
		else {
			[bag addObject:value];
			i++;
		}
	}
}

#pragma mark - Sort

// Location sort
+ (void) locationSort: (NSMutableArray *) array {
	
	NSDate * start = [NSDate date];
	
	//	NSLog(@"Coming in with array count: %i", array4.count);
	for (int i = 0; i<array.count; i++) {
		//		NSLog(@"Iterating with index: %li", i);
		NSInteger indexOfSmallest = [self indexOfSmallestWithStartingIndex:i andArray: array];
		NSNumber * smallest = array[indexOfSmallest];
		[array removeObjectAtIndex:indexOfSmallest];
		[array insertObject:smallest atIndex:i];
	}
	
	NSDate * end = [NSDate date];
	NSTimeInterval duration = [end timeIntervalSinceDate:start];
	NSLog(@"locationSort: completed in %f", duration);
	
	//	for (Person * person in array) {
	//		NSLog(@"LOCATION: print person with date: %@", person.birthDate);
	//	}
}


+ (NSInteger) indexOfSmallestWithStartingIndex: (NSInteger) index andArray: (NSMutableArray *) array {
	
	NSNumber * smallest = array[index];
	NSInteger indexOfSmallest = index;
	
	for (NSInteger i = index + 1; i < array.count; i++) {
		NSNumber * value = array[i];
		if (value < smallest) {
			smallest = value;
			indexOfSmallest = i;
		}
	}
	
	return indexOfSmallest;
}

// Insertion sort
+ (void) insertionSort: (NSMutableArray *) array {
	
	NSDate * start = [NSDate date];
	
	for (NSInteger i = 1; i < array.count; i++) {
		NSNumber * reference = array[i];
		
		NSInteger insertIndex = i;
		
		for (NSInteger j = i-1; j >= 0; j--) {
			NSNumber * incoming = array[j];
			if (incoming > reference) {
				insertIndex = j;
				// shift
				array[j+1] = array[j];
			}
			else {
				break;
			}
		}
		
		array[insertIndex] = reference;
	}
	
	NSDate * end = [NSDate date];
	NSTimeInterval duration = [end timeIntervalSinceDate:start];
	NSLog(@"Insertion completed with output: %@", array);
	NSLog(@"insertionSort: completed in %f", duration);

}




+ (void) mergeSort: (NSMutableArray *) array start: (NSInteger) start end: (NSInteger) end {
	
	if (end > start) {
		NSInteger q = (start + end) / 2;
		[self mergeSort:array start:start end:q];
		[self mergeSort:array start:q+1 end:end];
		[self merge:array start:start midPoint:q end:end];
	}
}


+ (void) merge: (NSMutableArray *) array start: (NSInteger) start midPoint: (NSInteger) midPoint end: (NSInteger) end {
	
	NSArray * lowHalf = [array subarrayWithRange:NSMakeRange(start, (midPoint - start) + 1)];
	NSArray * highHalf = [array subarrayWithRange:NSMakeRange(midPoint + 1, end - midPoint)];
	
	NSInteger indexLowHalf = 0;
	NSInteger indexUpperHalf = 0;
	
	for (NSInteger i = start; i <= end; i++) {
		if (indexLowHalf == lowHalf.count) {
			NSRange rangeOfRemaining = NSMakeRange(indexUpperHalf, highHalf.count - indexUpperHalf);
			NSArray * remaining = [highHalf subarrayWithRange:rangeOfRemaining];
			[array replaceObjectsInRange:NSMakeRange(i, remaining.count) withObjectsFromArray:remaining];
			break;
		}
		else if (indexUpperHalf == highHalf.count) {
			NSRange rangeOfRemaining = NSMakeRange(indexLowHalf, lowHalf.count - indexLowHalf);
			NSArray * remaining = [lowHalf subarrayWithRange:rangeOfRemaining];
			[array replaceObjectsInRange:NSMakeRange(i, remaining.count) withObjectsFromArray:remaining];
			break;
		}
		
		NSNumber * valueLowHalf = lowHalf[indexLowHalf];
		NSNumber * valueHighHalf = highHalf[indexUpperHalf];
		if (valueLowHalf < valueHighHalf) {
			array[i] = valueLowHalf;
			indexLowHalf += 1;
		}
		else {
			array[i] = valueHighHalf;
			indexUpperHalf += 1;
		}
	}
}


+ (void) doQuickSort: (NSMutableArray *) array startIndex: (NSInteger) start endIndex: (NSInteger) end {
	
	if (end > start) {
		NSInteger newPivotIndex = [self partition:array start: start end: end];
		
		[self doQuickSort:array startIndex: start endIndex: newPivotIndex - 1];
		[self doQuickSort:array startIndex: newPivotIndex + 1 endIndex: end];
	}
}

+ (NSInteger ) partition: (NSMutableArray *) array start: (NSInteger) start end: (NSInteger) end {
	
	NSInteger q = start;
	NSDate * reference = array[end];
	
	for (NSInteger j = start; j < end; j++) {
		
		if (array[j] < reference) {
			[self swap:array from:j to:q];
			q++;
		}
	}
	
	[self swap:array from:q to:end];
	
	return q;
}

+ (void) swap:(NSMutableArray *) array from: (NSInteger) from to: (NSInteger) to {
	
	id foo = array [from];
	array[from] = array[to];
	array[to] = foo;
	
}

#pragma mark - Recursion

+ (NSInteger) factorial: (NSInteger) value {
	NSInteger result = 1;
	
	for (NSInteger i = 1; i <= value; i++) {
		result = result * i;
		NSLog(@"Iterating with result: %li", result);
	}
	
	return result;
}

+ (NSInteger) recursiveFactorial: (NSInteger) n {
	
	if (n == 0) {
		return 1;
	}
	
	return n * ([self recursiveFactorial:(n -1)]);
}


+ (BOOL) isPalindrome: (NSString *) string {
	
	if (string.length <= 1) {
		return YES;
	}
	
	NSString * firstLetter = [string substringToIndex:1];
	NSString * lastLetter = [string substringFromIndex:string.length - 1];
	
	if ([firstLetter isEqualToString:lastLetter]) {
		NSString * substring = [string substringWithRange:NSMakeRange(1, string.length -2)];
		return [self isPalindrome: substring];
	}
	else {
		return NO;
	}
}


+ (NSInteger) calculate: (NSInteger) value toThePowerOf: (NSInteger) power {
	
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

+ (BOOL) isEven: (NSInteger) value {
	
	return (value % 2 == 0);
}

#pragma mark - Binary tree to list

+ (void) binaryTreeToList: (BinaryTree *) tree {
	
	
	NSMutableArray * queue = [NSMutableArray new];
	TreeNode * rootNode = tree.root;
	[queue addObject:rootNode];
	
	NSMutableArray * linkedList = [NSMutableArray new];
	
	[self doDepthFirstSearch:linkedList node: rootNode];
	
	NSLog(@"Finished traversing the binary tree with array: %@", linkedList);
}

+ (void) doBreadthFirstSearch: (NSMutableArray *) array queue: (NSMutableArray *) queue {

	
	if (!queue.count) {
		return;
	}
	
	TreeNode * node = queue [0];
	[array addObject:node.value];
	
	if (node.leftChild) {
		[queue addObject:node.leftChild];
	}
	if (node.rightChild) {
		[queue addObject:node.rightChild];
	}
	
	[queue removeObjectAtIndex:0];
	[self doBreadthFirstSearch:array queue:queue];
	
}

+ (void) doDepthFirstSearch: (NSMutableArray *) array node: (TreeNode *) node {

	if (node) {
		[self doDepthFirstSearch:array node:node.leftChild];
		[array addObject:node.value];
		[self doDepthFirstSearch:array node:node.rightChild];
	}
}

+ (LinkedList *) makeLinkedListFromArray: (NSArray *) array {
	
	LinkedList * list = [LinkedList new];
	
	for (NSNumber * number in array) {
		[list insertValue:number];
	}
	
	return list;
}

#pragma mark - Permutations

+ (void) setupPermutations {
	
	NSDictionary * map = @{@2 : @[@"A", @"B", @"C"],
						   @3 : @[@"D", @"E", @"F"],
						   @4 : @[@"G", @"H", @"I"],
								 @5 : @[@"J", @"K", @"L"],
						   @6 : @[@"M", @"N", @"O"],
						   @7 : @[@"P", @"Q", @"R", @"S"],
								 @8 : @[@"T", @"U", @"V"]};
	
	NSArray * input = @[@4, @6, @7];
	NSMutableArray * output = [NSMutableArray new];
	
	[self doPermutationsWithMap:map input:input output:output index:0 payload:@""];
	
}


+ (void) doPermutationsWithMap: (NSDictionary *) map input: (NSArray *) input output: (NSMutableArray *) output index: (NSInteger) index payload: (NSString *) payload  {

	if (index == input.count) {
		[output addObject:payload];
		return;
	}
	
	NSNumber * key = input[index];

	NSArray * options = [map objectForKey:key];
	
	for (NSInteger i = 0; i < options.count; i++) {
		NSString * newPayload = [payload copy];
		newPayload = [newPayload stringByAppendingString:options[i]];
		[self doPermutationsWithMap:map input:input output:output index:index + 1 payload:newPayload];
	}
}

+ (UIView *) findNearestCommonAncestor: (UIView *) first and: (UIView*) second {

	// Build a stack
	
	NSMutableArray * pathOne = [NSMutableArray new];
	UIView * superView = first.superview;
	
	while (superView) {
		[pathOne addObject:superView];
		superView = superView.superview;
	}
	
	NSMutableArray * pathTwo = [NSMutableArray new];
	superView = second.superview;
	
	while (superView) {
		[pathTwo addObject:superView];
		superView = superView.superview;
	}

	
	UIView * commonSuperview = nil;
	
	while (pathOne.count && pathTwo.count) {
		UIView * view1 = [pathOne lastObject];
		UIView * view2 = [pathTwo lastObject];
		
		if (view1 == view2) {
			commonSuperview = view1;
		}
		else {
			break;
		}
		
		[pathOne removeLastObject];
		[pathTwo removeLastObject];
	
	}

	return commonSuperview;
}

+ (void) divide: (NSInteger) total by: (NSInteger) value {
	
	NSInteger coefficient = 0;
	
	for (NSInteger i = 0; i < total; i ++) {
		if (i * value <= total) {
			coefficient = i;
		}
	}
}


#pragma mark - Helpers

+ (NSArray *) makeArrayOfIntsWithCapacity: (NSInteger) capacity {
	
	NSMutableArray * array = [NSMutableArray new];
	
	for (NSInteger i = 0; i < capacity; i++) {
		
		NSInteger random = arc4random_uniform(100);
		[array addObject:@(random)];
	}
	
	return array;
}


@end



@implementation Enumerator

- (instancetype)initWithData: (NSArray *) data
{
	self = [super init];
	if (self) {
		self.data = data;
		self.currentIndex = 0;
	}
	return self;
}

- (NSNumber *) next {

	if (self.currentIndex == self.data.count) { // out of bounds, bail
		return nil;
	}
	else {
		if (self.enumerator) { // we already have an enumerator set up, try to step through it
			id success = [self.enumerator next];
			
			if (success) {
				return success;
			}
			else { // the enumerator bailed, move to the next index
				self.enumerator = nil;
				return [self moveToNextIndex];
			}
		}
		else {
			return [self moveToNextIndex];
		}
	}
}

- (NSNumber *) moveToNextIndex {
	
	NSInteger current = self.currentIndex;
	self.currentIndex += 1;
	
//		NSArray * data = @[ @3,@[@8, @8, @17, @[@6, @7], @9], @3, @9, @[@42, @1, @7, @[@34, @12, @9], @7, @17], @45];
	
	if ([self.data[current] isKindOfClass:[NSArray class]]) { // Setup a new enumerator
		self.enumerator = [[Enumerator alloc]initWithData: self.data[current]];
		return self.enumerator.next;
	}
	else {
		return self.data[current];
	}
}

- (NSArray *) allObjects {
	
	NSMutableArray * retval = [NSMutableArray new];
	
	for (NSInteger i = 0; i < self.data.count; i++) {
		if ([self.data [i] isKindOfClass:[NSArray class]]){
			Enumerator * enumerator = [[Enumerator alloc]initWithData:self.data [i]];
			NSArray * objects = [enumerator allObjects];
			[retval addObjectsFromArray:objects];
		}
		else {
			[retval addObject:self.data [i]];
		}
	}
	
	return retval;
}


@end


@implementation BinaryTree

- (void) insertValue: (NSNumber *) value {
	
	TreeNode * node = [TreeNode new];
	node.value = value;
	
	
	if (!self.root) {
		self.root = node;
	}
	else {
		[self.root insertNode:node];
	}
}

@end


@implementation TreeNode

- (void) insertNode: (TreeNode *) node {
	if (node.value < self.value) {
		[self insertNodeOnLeftSide:node];
	}
	else {
		[self insertNodeOnRightSide:node];
	}
}

- (void) insertNodeOnLeftSide: (TreeNode *) node {
	if (self.leftChild) {
		[self.leftChild insertNode:node];
	}
	else {
		self.leftChild = node;
	}
}

- (void) insertNodeOnRightSide: (TreeNode *) node {
	if (self.rightChild) {
		[self.rightChild insertNode:node];
	}
	else {
		self.rightChild = node;
	}
}

@end

@implementation LinkedList


- (void) insertValue: (NSNumber *) value {
	
	if (!self.head) {
		
		LinkedListItem * head = [LinkedListItem new];
		head.value = value;
		self.head = head;
	}
	else {
		
		LinkedListItem * new = [LinkedListItem new];
		new.value = value;
		
		[self.head insertItem: new];
	}
}


- (void) swapNodes {
	
	LinkedListItem * head = self.head.nextItem;
	
	[self swapNodesForNode:self.head];
	self.head = head;
	
}

- (void) swapNodesForNode: (LinkedListItem *) node {
	
	
	if (!node.nextItem) {
		return;
	}
	
	LinkedListItem * nextPair = node.nextItem.nextItem; // the begginning of the next pair
	
	node.nextItem.nextItem = node;
	if (nextPair.nextItem)
	{
		node.nextItem = nextPair.nextItem;
	}
	else {
		node.nextItem = nextPair;
	}
	
	[self swapNodesForNode:nextPair];
	
}

- (void) printList {
	
	[self.head printValue];
	
}


@end


@implementation LinkedListItem

- (void) printValue {
	
	printf ("%s\n", [[NSString stringWithFormat:@"%@ --> ", self.value] UTF8String]);
	[self.nextItem printValue];
	
}

- (void) insertItem: (LinkedListItem *) item {
	
	if (self.nextItem) {
		[self.nextItem insertItem:item];
	}
	else {
		self.nextItem = item;
	}
	
}


@end
