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
+ (void) compareSort: (NSArray *) array {
	
	NSDate * start = [NSDate date];
	
	NSArray * sortedArray __attribute__((unused)) = [array sortedArrayUsingSelector:@selector(compare:)];
	
	NSDate * end = [NSDate date];
	NSTimeInterval duration = [end timeIntervalSinceDate:start];
	NSLog(@"compareSort: completed in %f", duration);
}

// Second method (using sort descriptors)
+ (void) sortDescriptorsSort: (NSArray *) array {
	
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
+ (void) compareSort2: (NSArray *) array {
	
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
+ (void) blockCompare: (NSArray *) array {
	
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
+ (void) locationSort: (NSMutableArray *) array {
	
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


+ (NSInteger) indexOfSmallestWithStartingIndex: (NSInteger) index andArray: (NSMutableArray *) array {
	
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
+ (void) insertionSort: (NSMutableArray *) array {
	
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


+ (NSInteger) slideFromIndex: (NSInteger) index array: (NSMutableArray *) array value: (NSDate *) date {
	
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


+ (NSArray *) mergeSort: (NSArray *) array {
	
	if (array.count <2) {
		return array;
	}
	
	// split the array
	
	NSInteger middleIndex = array.count / 2;
	
	NSRange leftRange = NSMakeRange(0, middleIndex);
	NSRange rightRange = NSMakeRange(middleIndex, array.count - middleIndex);
	
	NSArray * leftUnsorted = [array subarrayWithRange:leftRange];
	NSArray * rightUnsorted = [array subarrayWithRange:rightRange];
	
	NSArray * leftSorted = [self mergeSort:leftUnsorted];
	NSArray * rightSorted = [self mergeSort:rightUnsorted];
	
	return [self merge:leftSorted withArray:rightSorted];
	
}



+ (NSArray*) merge: (NSArray *) first withArray: (NSArray *)second {
	
	NSMutableArray * result = [@[]mutableCopy];
	NSInteger indexFirst = 0;
	NSInteger indexSecond = 0;
	
	while (indexFirst <= first.count && indexSecond <= second.count) {
		
		if (indexFirst == first.count) {
			// first array is depleted, append the elements remaining in second to the result
			
			NSRange range = NSMakeRange(indexSecond, second.count - indexSecond);
			[result addObjectsFromArray:[second subarrayWithRange:range]];
			
			break;
		} else if (indexSecond == second.count){
			// second array is depleted, append the elements remaining in the first to the result
			
			NSRange range = NSMakeRange(indexFirst, first.count - indexFirst);
			[result addObjectsFromArray:[first subarrayWithRange:range]];
			break;
		}
		
		Person * personFirst = first[indexFirst];
		Person * personSecond = second[indexSecond];
		
		if ([personFirst.birthDate compare:personSecond.birthDate] == NSOrderedAscending) {
			
			[result addObject:personFirst];
			indexFirst += 1;
		}
		else if ([personFirst.birthDate compare:personSecond.birthDate] == NSOrderedDescending) {
			[result addObject:personSecond];
			indexSecond += 1;
		}
		else {
			[result addObject:personFirst];
			indexFirst += 1;
			[result addObject:personSecond];
			indexSecond += 1;
		}
	}
	
	
	
	return result;
}


+ (void) doQuickSort: (NSMutableArray *) array startIndex: (NSInteger) start endIndex: (NSInteger) end {
	
	if (start < end) {
		NSInteger newPivotIndex = [self partition:array start: start end: end];
		
		[self doQuickSort:array startIndex: start endIndex: newPivotIndex - 1];
		[self doQuickSort:array startIndex: newPivotIndex + 1 endIndex: end];
	}
}

+ (NSInteger ) partition: (NSMutableArray *) array start: (NSInteger) start end: (NSInteger) end {
	
	
	NSInteger q = start;
	NSDate * referenceDate = ((Person *)array[end]).birthDate;
	
	
	for (NSInteger j = start; j < end; j++) {
		Person * incoming = array[j];
		
		if ([incoming.birthDate compare:referenceDate]==NSOrderedAscending) {
			[self swap:array from:j to:q];
			q++;
		}
	}
	
	[self swap:array from:q to:end];
	
	
	return q;
}

+ (void) swap:(NSMutableArray *) array from: (NSInteger) from to: (NSInteger) to {
	
	Person * person = array [from];
	array[from] = array[to];
	array[to] = person;
	
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


#pragma mark - Helpers

+ (NSArray *) makeArrayOfNamesWithCapacity: (NSInteger) capacity {
	
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
	
	
	
	NSMutableArray * returnArray = [@[]mutableCopy];
	
	for (NSInteger i = 0; i < capacity; i++){
		NSInteger random = arc4random_uniform(12);
		[returnArray addObject:names [random]];
	}
	
	return [returnArray copy];
	
}

+ (NSArray *) makeArrayOfDatesWithCapacity: (NSInteger) capacity {
	
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
