function [h,k]  = fitting (x1,x2,y1,y2,cx,cy)
    px = x2-x1;
    py = y2-y1;
    dAB = px*px + py*py;
    u = ((cx - x1) * px + (cy - y1) * py) / dAB;
    h = x1 + u * px; k = y1 + u * py;
end