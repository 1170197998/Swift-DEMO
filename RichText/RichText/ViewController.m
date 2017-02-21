//
//  ViewController.m
//  RichText
//
//  Created by ShaoFeng on 2017/2/21.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "SecondViewController.h"
@interface ViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)UITextView *textView;

@property (nonatomic,strong)NSMutableArray *imageArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [NSMutableArray array];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
    self.textView.scrollEnabled = YES;
    self.textView.backgroundColor = [UIColor grayColor];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:self.textView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1];
    btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - 40, 80, 30);
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:@"添加图片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    
}
- (IBAction)push:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *receive = [storyboard instantiateViewControllerWithIdentifier:@"second"];
    receive.htmlString = [ViewController attriToStrWithAttri:self.textView.attributedText];
    [self.navigationController pushViewController:receive animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}

- (void)addImage
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDate *now = [NSDate date];
    NSString *imageName = [NSString stringWithFormat:@"iOS%@.jpg", [self stringFromDate:now]];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image;
    if ([mediaType isEqualToString:@"public.image"])
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [imageData writeToFile:imagePath atomically:YES];
    }
    
    NSInteger userid = 12345;
    //对应自己服务器的处理方法,
    //此处是将图片上传ftp中特定位置并使用时间戳命名 该图片地址替换到html文件中去
    NSString *url = [NSString stringWithFormat:@"http://baidu/images/%@/%@/%@",[NSString stringWithFormat:@"%ld",userid%1000],[NSString stringWithFormat:@"%ld",(long)userid],imageName];
    NSLog(@"%@",url);
    NSDictionary *dic = @{@"url":url,@"image":image,@"name":imageName};
    [self uploadImage:image];
    [self.imageArray addObject:dic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage:(UIImage *)image
{
    [self.textView replaceRange:self.textView.selectedTextRange withText:@"\n"];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(0, 10, SCREEN_WIDTH / 2, (image.size.height / (image.size.width / SCREEN_WIDTH)) / 2);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [strM replaceCharactersInRange:self.textView.selectedRange withAttributedString:imageText];
    [strM addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(self.textView.selectedRange.location, 1)];
    self.textView.attributedText = strM;
    self.textView.selectedRange = NSMakeRange(self.textView.selectedRange.location + 1,0);
    [self.textView.delegate textViewDidChange:self.textView];
}

- (void)textViewDidChange:(UITextView *)textView
{

}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

- (IBAction)save:(id)sender {
    
    NSLog(@"富文本-----%@",self.textView.attributedText);
    NSLog(@"-----------");
    NSLog(@"html字符串-----%@",[ViewController attriToStrWithAttri:self.textView.attributedText]);
}

+ (NSString *)attriToStrWithAttri:(NSAttributedString *)attri{
    NSDictionary *tempDic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [attri dataFromRange:NSMakeRange(0, attri.length)
                         documentAttributes:tempDic
                                      error:nil];
    return [[NSString alloc] initWithData:htmlData
                                 encoding:NSUTF8StringEncoding];
}



@end
