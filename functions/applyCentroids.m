function [I] = applyCentroids(X,C)
%UNTITLED Summary of this function goes here
%   X - multiband data to apply centroids to
%   C - centroid values for each band for each centroid
%   I- index image with integer values for each pixel which correspond to
%   the centroid the pixel belongs to. NaN for invalid pixels.

[nrows,ncols,sz]=size(X);
X=reshape(X,nrows*ncols,sz);
X=double(X);
noData=any(X==0,2);
X(noData,:)=NaN;
[~,I]=pdist2(C,double(X),...
        'euclidean','Smallest',1);    
I=reshape(I,nrows,ncols);
noData=reshape(noData,nrows,ncols);
I(noData)=NaN;
end

