function [x1,y1]=drawellipse1(E,l,m,A,B,C,D,F,G)
%This function uses ellipse quadratic parameters to calculate the ellipse
%standard parameters and then plots a part of the ellipse between two
%points stored in E(l,1:2) and E(m,1:2)


   e = 4*A*C-B^2; %if e<=0, error('This conic is not an ellipse.'), end
   % Ellipse center
   x0 = (B*F-2*C*D)/e; 
   y0 = (B*D-2*A*F)/e;
   
   F0 = -2*(A*x0^2+B*x0*y0+C*y0^2+D*x0+F*y0+G);
   g1 = sqrt((A-C)^2+B^2); 
   a1 = F0/(A+C+g1); 
   b1 = F0/(A+C-g1);
   
   %if (a1<=0)|(b1<=0), error('This is a degenerate ellipse.'), end
   
   % Major & minor axes
   a1 = sqrt(a1);  
   b1 = sqrt(b1);
   
   t = 1/2*atan2(B,A-C); 
   ct = cos(t); 
   st = sin(t);%Rotation angle
   
   p = linspace(0,2*pi,500); 
   cp = cos(p); 
   sp = sin(p);%Variable parameter
   
   % Generate points on ellipse
   x = x0+a1*ct*cp-b1*st*sp; 
   y = y0+a1*st*cp+b1*ct*sp; 
   
   %Calculate angles between which ellipse should be plotted
   angle1=angle2points1(x0,y0,E(l,1),E(l,2));
   angle2=angle2points1(x0,y0,E(m,1),E(m,2));
%    plot(E(l,1),E(l,2),'gx');
%    plot(E(m,1),E(m,2),'bx');
%    plot(x0,y0,'rx');
   angle1=angle1-0.1;
   angle2=angle2+0.1;
   %Store the ellipse points in x1, y1
   count=1;x1=0;y1=0;
   for z=1:500
       if angle1<angle2        
           if (angle2points1(x0,y0,x(z),y(z))>angle1 && angle2points1(x0,y0,x(z),y(z))<angle2) 
               x1(count)=x(z);
               y1(count)=y(z);
               count=count+1;
           end
       elseif angle1>angle2
           if (angle2points1(x0,y0,x(z),y(z))>angle1) || (angle2points1(x0,y0,x(z),y(z))<angle2)
               x1(count)=x(z);
               y1(count)=y(z);
               count=count+1;
           end
       end
   end
   
   %Sort the values from first to last
   for z=1:count-2
       if dist2points(x1(z),y1(z),x1(z+1),y1(z+1))>5
           x1=[(x1((z+1):count-1)) (x1(1:z))];
           y1=[(y1((z+1):count-1)) (y1(1:z))];
       end
   end
end