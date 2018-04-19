function [d]=div(IdSmall,centroids,s,pointX,pointY)
%Calculates the divergence of a seedpoint-edgepixel pair for relevance
%metric
    [Gmag,Gdir] = imgradient(IdSmall);    
    for gdistVar=1:length(s)
        dir=angle2points(centroids(gdistVar,1),centroids(gdistVar,2),pointX,pointY);
        dArray(gdistVar)=cos(degtorad(Gdir(pointX,pointY))-atan(dir));  
    end
    d=min(dArray);
end