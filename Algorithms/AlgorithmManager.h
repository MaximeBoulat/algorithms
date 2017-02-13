//
//  AlgorithmManager.h
//  Algorithms
//
//  Created by Maxime Boulat on 2/10/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinaryTree.h"
#import <UIKit/UIKit.h>

@interface AlgorithmManager : NSObject

+ (void) doBinarySearch;
+ (void) compareSort: (NSArray *) array;
+ (void) sortDescriptorsSort: (NSArray *) array;
+ (void) compareSort2: (NSArray *) array;
+ (void) blockCompare: (NSArray *) array;
+ (void) locationSort: (NSMutableArray *) array;
+ (void) insertionSort: (NSMutableArray *) array;
+ (void) mergeSort: (NSMutableArray *) array start: (NSInteger) start end: (NSInteger) end;
+ (void) doQuickSort: (NSMutableArray *) array startIndex: (NSInteger) start endIndex: (NSInteger) end;
+ (NSInteger) factorial: (NSInteger) value;
+ (NSInteger) recursiveFactorial: (NSInteger) n;
+ (BOOL) isPalindrome: (NSString *) string;
+ (NSInteger) calculate: (NSInteger) value toThePowerOf: (NSInteger) power;

+ (NSMutableArray *) makeArrayOfPeopleWithCapacity: (NSInteger) capacity;
+ (NSArray *) makeArrayOfNamesWithCapacity: (NSInteger) capacity;
+ (NSArray *) makeArrayOfDatesWithCapacity: (NSInteger) capacity;
+ (NSArray *) makeArrayOfIntsWithCapacity: (NSInteger) capacity;

+ (void) pushZeroes: (NSMutableArray *) array;
+ (void) pullZeroes: (NSMutableArray *) array ;
+ (void) removeDuplicates: (NSMutableArray *) array;

+ (void) binaryTreeToList: (BinaryTree *) tree;

+ (LinkedList *) makeLinkedListFromArray: (NSArray *) array;

+ (void) setupPermutations;
+ (UIView *) findCommonSuperview: (UIView *) first and: (UIView*) second;
+ (void) divide: (NSInteger) total by: (NSInteger) value;

@end

@interface Person : NSObject

@property (nonatomic, copy) NSString * firstName;
@property (nonatomic, retain) NSDate * birthDate;

- (instancetype)initWithDate: (NSDate *) date andName: (NSString *) name;
- (NSComparisonResult)compare:(id)other;

@end

@interface Item : NSObject

@property (nonatomic, strong) Item * sibling;

@end

@interface PermutationOperation : NSObject

@property (nonatomic, strong) NSNumber * row;
@property (nonatomic, strong) NSNumber * column;
@property (nonatomic, strong) NSString * payload;

@end
