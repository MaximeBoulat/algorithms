//
//  AlgorithmManager.h
//  Algorithms
//
//  Created by Maxime Boulat on 2/10/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlgorithmManager : NSObject

+ (void) doBinarySearch;
+ (void) compareSort: (NSArray *) array;
+ (void) sortDescriptorsSort: (NSArray *) array;
+ (void) compareSort2: (NSArray *) array;
+ (void) blockCompare: (NSArray *) array;
+ (void) locationSort: (NSMutableArray *) array;
+ (void) insertionSort: (NSMutableArray *) array;
+ (NSInteger) slideFromIndex: (NSInteger) index array: (NSMutableArray *) array value: (NSDate *) date;
+ (void) mergeSort: (NSMutableArray *) array start: (NSInteger) start end: (NSInteger) end;
+ (void) doQuickSort: (NSMutableArray *) array startIndex: (NSInteger) start endIndex: (NSInteger) end;
+ (NSInteger) factorial: (NSInteger) value;
+ (NSInteger) recursiveFactorial: (NSInteger) n;
+ (BOOL) isPalindrome: (NSString *) string;
+ (NSInteger) calculate: (NSInteger) value toThePowerOf: (NSInteger) power;

+ (NSArray *) makeArrayOfNamesWithCapacity: (NSInteger) capacity;
+ (NSArray *) makeArrayOfDatesWithCapacity: (NSInteger) capacity;

+ (NSArray *) makeArrayOfIntsWithCapacity: (NSInteger) capacity;
+ (void) pushZeroes: (NSMutableArray *) array;
+ (void) pullZeroes: (NSMutableArray *) array ;

@end

@interface Person : NSObject

@property (nonatomic, copy) NSString * firstName;
@property (nonatomic, retain) NSDate * birthDate;

- (instancetype)initWithDate: (NSDate *) date andName: (NSString *) name;
- (NSComparisonResult)compare:(id)other;

@end
