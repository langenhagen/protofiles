// author: langenhagen
// version: 17-08-04

// -------------------------------------------------------------------------------------------------

// To ease adoption of the new annotations, you can mark certain regions of your Objective-C header
// files as audited for nullability. Within these regions, any simple pointer type
// will be assumed to be nonnull.

NS_ASSUME_NONNULL_BEGIN

NS_ASSUME_NONNULL_END

// -------------------------------------------------------------------------------------------------
// classes

@interface MyClass : NSObject

- (void)dealloc

@end


@implementation MyClass

- (void)dealloc
{
    NSLog( @"dealloc is totally optional :)");
}

@end

// -------------------------------------------------------------------------------------------------
// dynamically allocate memory

MyClass obj1 = [MyClass new];               // works
MyClass obj2 = [[MyClass alloc] init]       // works, too :)
MyClass obj3 = [[MyClass alloc] initWithCustomInitializerThatTakesParam:myParam1 param2:myParam2];



// -------------------------------------------------------------------------------------------------
// pointers

id<FooProtocol> pointerToObjectThatConformsToFooProtocol = [[MyClass alloc] init];

// -------------------------------------------------------------------------------------------------
// generics

NSMutableSet< Cat *> cats = [[NSMutableSet alloc] init];
NSDictionary<KeyType *, ValueType *> dict = [[NSDictionary alloc] init];


// -------------------------------------------------------------------------------------------------
// categories - aka extend classes

@interface MyClass (MyCategory)

- (void)myAdditionalFunction;
- (void)myExtendedAdditionalFunction;

@end

// -------------------------------------------------------------------------------------------------
//