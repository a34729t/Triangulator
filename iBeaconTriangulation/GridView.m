//
//  From http://stackoverflow.com/questions/18226496/how-to-draw-grid-lines-when-camera-is-open-avcapturemanager
//

#import "GridView.h"

@interface GridView ()

@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic, assign) int numberOfRows;

@end


@implementation GridView

- (id)initWithFrame:(CGRect)frame columns:(int)columns
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Set size of grid
        self.numberOfColumns = columns-1;
        
        // Set view to be transparent
        self.opaque = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    // ---------------------------
    // Drawing column lines
    // ---------------------------
    
    // calculate column width
    CGFloat columnWidth = self.frame.size.width / (self.numberOfColumns + 1.0);
    
    
    
    for(int i = 1; i <= self.numberOfColumns; i++)
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = columnWidth * i;
        startPoint.y = 0.0f;
        
        endPoint.x = startPoint.x;
        endPoint.y = self.frame.size.height;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
    
    // ---------------------------
    // Drawing row lines
    // ---------------------------
    
    // calclulate row height
    CGFloat rowHeight = columnWidth;
    self.numberOfRows = self.frame.size.height/rowHeight;
    
    for(int j = 1; j <= self.numberOfRows; j++)
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = 0.0f;
        startPoint.y = rowHeight * j;
        
        endPoint.x = self.frame.size.width;
        endPoint.y = startPoint.y;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
}

@end
