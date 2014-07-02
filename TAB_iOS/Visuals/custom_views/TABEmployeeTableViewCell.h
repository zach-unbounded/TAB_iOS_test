//
//  TABEmployeeTableViewCell.h
//  TAB_iOS
//
//  Created by Zachary BURGESS on 02/07/2014.
//  Copyright (c) 2014 Zachary BURGESS. All rights reserved.
//

@class TABEmployee;

@interface TABEmployeeTableViewCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView * image_img;

@property (weak,nonatomic) IBOutlet UILabel * name_lbl;

@property (weak,nonatomic) IBOutlet UILabel * title_lbl;

@property (weak,nonatomic) IBOutlet UILabel * miniBio_lbl;

- (void)setEmployee:(TABEmployee*)paramEmployee;

+ (NSString *)reuseIdentifier;

+ (CGFloat)cellHeightWithBioText:(NSString*)paramText;

- (CGFloat)height;

@end
