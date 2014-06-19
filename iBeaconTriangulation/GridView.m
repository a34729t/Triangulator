//
//  From http://stackoverflow.com/questions/18226496/how-to-draw-grid-lines-when-camera-is-open-avcapturemanager
//

#import "GridView.h"

@interface GridView ()

@property (nonatomic, assign) CGFloat gridWidth;
@property (nonatomic, assign) int columns;

@end


@implementation GridView

- (id)initWithFrame:(CGRect)frame columns:(int)columns
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set size of grid
        self.gridWidth = 0.5;
        self.columns = columns-1;
        
        // Set view to be transparent
        self.opaque = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.gridWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    // Calculate basic dimensions
    CGFloat columnWidth = self.frame.size.width / (self.columns + 1.0);
    CGFloat rowHeight = columnWidth;
    int numberOfRows = self.frame.size.height/rowHeight;
    
    // ---------------------------
    // Drawing column lines
    // ---------------------------
    for(int i = 1; i <= self.columns; i++)
    {
        CGPoint startPoint = CGPointMake(columnWidth * i, 0.0f);
        CGPoint endPoint  = CGPointMake(startPoint.x, self.frame.size.height);
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
    
    // ---------------------------
    // Drawing row lines
    // ---------------------------
    for(int j = 1; j <= numberOfRows; j++)
    {
        CGPoint startPoint = CGPointMake(0.0f, rowHeight * j);
        CGPoint endPoint  = CGPointMake(self.frame.size.width, startPoint.y);
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
}

@end
