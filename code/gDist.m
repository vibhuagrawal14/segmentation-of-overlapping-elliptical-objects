function [d]=gdist(centroids,s,pointX,pointY)
    for gdistVar=1:length(s)
        dArray(gdistVar)=dist2points(centroids(gdistVar,1),centroids(gdistVar,2),pointX, pointY);
    end
    d=min(dArray);
end