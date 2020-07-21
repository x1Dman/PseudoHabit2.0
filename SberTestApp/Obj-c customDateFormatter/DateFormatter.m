//
//  myCustomFormatter.m
//  SberTestApp
//
//  Created by Nikita Khusnutdinov on 7/17/20.
//  Copyright © 2020 Nikita Khusnutdinov. All rights reserved.
//

#import "DateFormatter.h"

@interface ObjCDateFormatter()
@property (strong, nonatomic) NSString *textFormat;
@end

@implementation ObjCDateFormatter

-(NSString *) getDateStringFrom: (NSDate *)date {
    // alloc memory for dateformatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: _textFormat];
    NSString *returnValue = [dateFormatter stringFromDate: date];
    return returnValue;
}
- (void) setFormat:(NSString *)text {
    _textFormat = text;
}

@end

