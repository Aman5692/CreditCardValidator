//
//  ViewController.m
//  CreditCardValidator
//
//  Created by Aman Agarwal on 07/04/19.
//  Copyright © 2019 Assignment. All rights reserved.
//

#import "ViewController.h"
#import "CreditCardView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CreditCardView *cardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardView.layer.masksToBounds = YES;
    self.cardView.layer.cornerRadius = 10;
    // Do any additional setup after loading the view, typically from a nib.
}


@end
