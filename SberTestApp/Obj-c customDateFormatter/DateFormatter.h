//
//  myCustomFormatter.h
//  SberTestApp
//
//  Created by Nikita Khusnutdinov on 7/17/20.
//  Copyright © 2020 Nikita Khusnutdinov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjCDateFormatter : NSObject

-(NSString *) getDateStringFrom: (NSDate *)date;
-(void) setFormat: (NSString *)textFormat;

@end
