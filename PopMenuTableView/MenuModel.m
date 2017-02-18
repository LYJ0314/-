//
//  MenuModel.m
//  PopMenuTableView
//


#import "MenuModel.h"

@implementation MenuModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)MenuModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
