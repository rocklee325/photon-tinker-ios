//
//  SPKPinFunctionView.m
//  Spark IOS
//
//  Copyright (c) 2013 Spark Devices. All rights reserved.
//

#import "SPKPinFunctionView.h"

#define selectedColor       [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]
#define unselectedColor     [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]

@interface SPKPinFunctionView() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *editPinNameButton;
@property (weak, nonatomic) IBOutlet UITextField *editPinNameTextField;
@end

@implementation SPKPinFunctionView

- (void)setPin:(SPKCorePin *)pin
{
    _pin = pin;

    self.pinLabel.text = _pin.label;

    self.analogReadImageView.hidden = YES;
    self.analogReadButton.backgroundColor = unselectedColor;
    self.analogWriteImageView.hidden = YES;
    self.analogWriteButton.backgroundColor = unselectedColor;
    self.digitalReadImageView.hidden = NO;
    self.digitalReadButton.backgroundColor = unselectedColor;
    self.digitalWriteImageView.hidden = NO;
    self.digitalWriteButton.backgroundColor = unselectedColor;

    if ((pin.availableFunctions & SPKCorePinFunctionAnalogRead) == SPKCorePinFunctionAnalogRead) {
        self.analogReadButton.hidden = NO;
        self.analogReadImageView.hidden = NO;

    } else {
        self.analogReadButton.hidden = YES;
        self.analogReadImageView.hidden = YES;

    }

    if ((pin.availableFunctions & SPKCorePinFunctionAnalogWrite) == SPKCorePinFunctionAnalogWrite) {
        self.analogWriteButton.hidden = NO;
        self.analogWriteImageView.hidden = NO;

    } else {
        self.analogWriteButton.hidden = YES;
        self.analogWriteImageView.hidden = YES;

    }

    switch (_pin.selectedFunction) {
        case SPKCorePinFunctionAnalogRead:
            self.analogReadButton.backgroundColor = selectedColor;
            self.analogReadImageView.hidden = NO;
            break;

        case SPKCorePinFunctionAnalogWrite:
            self.analogWriteButton.backgroundColor = selectedColor;
            self.analogWriteImageView.hidden = NO;
            break;

        case SPKCorePinFunctionDigitalRead:
            self.digitalReadButton.backgroundColor = selectedColor;
            self.digitalReadImageView.hidden = NO;
            break;

        case SPKCorePinFunctionDigitalWrite:
            self.digitalWriteButton.backgroundColor = selectedColor;
            self.digitalWriteImageView.hidden = NO;
            break;

        default:
            break;
    }
    
    [self.pinLabel sizeToFit];

}

- (IBAction)functionSelected:(id)sender
{
    SPKCorePinFunction function = SPKCorePinFunctionNone;

    if (sender == self.analogReadButton) {
        function = SPKCorePinFunctionAnalogRead;
    } else if (sender == self.analogWriteButton) {
        function = SPKCorePinFunctionAnalogWrite;
    } else if (sender == self.digitalReadButton) {
        function = SPKCorePinFunctionDigitalRead;
    } else if (sender == self.digitalWriteButton) {
        function = SPKCorePinFunctionDigitalWrite;
    }

    [self.delegate pinFunctionSelected:function];
}


-(void)setEditingPinName:(BOOL)editingPinName
{
    if (editingPinName)
    {
        self.editPinNameTextField.hidden = NO;
        self.editPinNameButton.hidden = YES;
        self.editPinNameTextField.delegate = self;
        self.pinLabel.hidden = YES;
        [self.editPinNameTextField becomeFirstResponder];
    }
    else
    {
        self.editPinNameTextField.hidden = YES;
        self.editPinNameButton.hidden = NO;
        self.pinLabel.hidden = NO;
    }
}


- (IBAction)editPinNameButtonTapped:(id)sender
{
    self.editingPinName = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    //.. do something with new name
    if (textField == self.editPinNameTextField)
    {
        self.pinLabel.text = textField.text;
        self.pin.label = textField.text;
        self.editingPinName = NO;
        [self.delegate pinNameChangedTo:self.pin.label];
        // update pinview
    }
    
    return YES;
}
@end
