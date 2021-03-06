//
//  HomeViewController.m
//  Xmazon
//
//  Created by guillaume chieb bouares on 20/01/2016.
//  Copyright (c) 2016 com.esgi. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *goToCart;

@end
@implementation HomeViewController

@synthesize products = _products;
static NSString* KEY_ACCESS_TOKEN = @"access_token";
static NSString* USERDEFAULT_KEY_USER = @"user";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Accueil";
    [self loadProduct];
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Images/reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem* cartButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Images/shopping-cart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openCart)];
    self.navigationItem.rightBarButtonItem = cartButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)openCart{
    
    CartViewController* v = [CartViewController new];
    [self.navigationController pushViewController:v animated:YES];
}
-(void)loadProduct{
    XMApiService* apiService = [[XMApiService alloc]init];
    if([XMSessionDataSingleton sharedSession].products == nil) {
        [apiService cheatGetAllProducts:^(NSArray *products) {
            self.products = products;
            [XMSessionDataSingleton sharedSession].products = self.products;
            NSLog(@"%@",self.products);
            [self.productTableView reloadData];
        } failure:^{
            NSLog(@"test");
        }];
    }else {
        self.products = [XMSessionDataSingleton sharedSession].products;
    }
    
    if(self.products){
        NSLog(@"%@",self.products);
        [self.productTableView reloadData];
    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.products count];
}

static NSString* const kCellReuseIdentifier = @"CoolId";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellReuseIdentifier];
    }
    XMProduct* product = [self.products objectAtIndex:indexPath.row];
    cell.textLabel.text = product.name;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
