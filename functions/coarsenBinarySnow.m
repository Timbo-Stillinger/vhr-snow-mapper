function [truthFsca,coarseFill, coarseR, M, newR] = coarsenBinarySnow(binaryTruth,outProj,targetRes)
%COARSENBINARYSNOW Summary of this function goes here
%BinaryTruth - binary snow cover with three values
%B.snowmask is the snowmask with three possible values:
   % 0- No Snow Bare Groud measured
   % 1- Snow covered pixel
   % 2- Fill pixels - no data.fillVal snowVal snowfreeVal];
   %B.smowmaskR -reference matrix for snowmask
   %B.projectionStructure - projection structure for snowmask
%outProj
   %outProj.ProjectionStructure
   %outProj.RasterReference
   %snow free is fsca==0
   
    fillValue=2;
    snowValue=1;
    
    
    [truthFsca, coarseR, M, newR]=doCoarsen(binaryTruth,outProj,snowValue,targetRes);
    coarseFill=doCoarsen(binaryTruth,outProj,fillValue,targetRes);
    
    %fill if more than 5% is fill in coarse pixel or out of range of original image extent
    coarseFill=coarseFill>0.05 | isnan(truthFsca);
    truthFsca(coarseFill)=NaN;
end

function [coarseWV, coarseR, M, newR]=doCoarsen(B,outProj,V,targetRes)
%B- Binary snowmask
%V - value to coarsen (fill or fsca)
%targetRes in meters
%referenceinfo for reprojeciton

M=single(B.snowmask==V);
origSz=size(M);


N=floor(log2(targetRes/B.snowmaskR(2,1)));
for i=1:N
    M=impyramid(M,'reduce');
end
[x11, y11]=pix2map(B.snowmaskR,1,1);
dx=B.snowmaskR(2,1);
dy=B.snowmaskR(1,2);
adjustment = origSz./size(M);
newdy = dy*adjustment(1);
newdx = dx*adjustment(2);
x11 = x11+(newdx-dx);
y11 = y11+(newdy-dy);
dx = newdx;
dy = newdy;
newR = makerefmat(x11,y11,dx,dy);
[coarseWV,coarseR]=rasterReprojection(M,newR,B.ProjectionStructure,...
    outProj.ProjectionStructure,'rasterref',outProj.RasterReference);
end