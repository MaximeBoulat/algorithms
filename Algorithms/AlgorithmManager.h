//
//  AlgorithmManager.h
//  Algorithms
//
//  Created by Maxime Boulat on 2/10/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TreeNode : NSObject

@property (nonatomic, strong) NSNumber * value;
@property (nonatomic, strong) TreeNode * leftChild;
@property (nonatomic, strong) TreeNode * rightChild;

- (void) insertNode: (TreeNode *) node;

@end

@interface BinaryTree : NSObject

@property (nonatomic, strong) TreeNode * root;

- (void) insertValue: (NSNumber *) value;

@end

@interface LinkedListItem : NSObject

@property (nonatomic, strong) NSNumber * value;
@property (nonatomic, strong) LinkedListItem * nextItem;

- (void) insertItem: (LinkedListItem *) item;
- (void) printValue;

@end

@interface LinkedList : NSObject

@property (nonatomic, strong) LinkedListItem * head;

- (void) insertValue: (NSNumber *) value;
- (void) swapNodes;
- (void) printList;

@end

@interface AlgorithmManager : NSObject

+ (void) doBinarySearch;
+ (void) locationSort: (NSMutableArray *) array;
+ (void) insertionSort: (NSMutableArray *) array;
+ (void) mergeSort: (NSMutableArray *) array start: (NSInteger) start end: (NSInteger) end;
+ (void) doQuickSort: (NSMutableArray *) array startIndex: (NSInteger) start endIndex: (NSInteger) end;
+ (NSInteger) factorial: (NSInteger) value;
+ (NSInteger) recursiveFactorial: (NSInteger) n;
+ (BOOL) isPalindrome: (NSString *) string;
+ (NSInteger) calculate: (NSInteger) value toThePowerOf: (NSInteger) power;

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


@interface Enumerator : NSObject

@property (nonatomic, strong) NSArray * data;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) Enumerator * enumerator;

- (instancetype)initWithData: (NSArray *) data;
- (NSNumber *) next;
- (NSArray *) allObjects;

@end
