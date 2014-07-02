//
//  TABEmployeeTableViewCell.m
//  TAB_iOS
//
//  Created by Zachary BURGESS on 02/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

#import "TABEmployeeTableViewCell.h"
#import "TABEmployee.h"

@implementation TABEmployeeTableViewCell

+ (NSString *)reuseIdentifier {
    return @"CELL";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setEmployee:(TABEmployee*)paramEmployee {
    self.name_lbl.text = paramEmployee.name;
    self.title_lbl.text = paramEmployee.title;
    self.miniBio_lbl.text = paramEmployee.miniBio;
}

@end
