//
//  TextFieldTableViewCell.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 16/08/23.
//

#import "TextFieldTableViewCell.h"

@interface TextFieldTableViewCell () <UITextFieldDelegate>

@end



@implementation TextFieldTableViewCell

- (void) awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textField.delegate = self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) configureWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    self.label.text = title;
    self.textField.placeholder = placeholder;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}


@end
