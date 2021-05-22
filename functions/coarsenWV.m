function [wvFsca,wvFill, coarseR, M, newR] = coarsenWV(wvTruth,productFSCA,wvVal,rFlag,targetRes)
%COARSENWV Summary of this function goes here
%wvVal - [fillVal snowVal snowfreeVal];
%rFlag - coarsen 7 band data instead of logical snow mask
if~rFlag
    % %     wv=load(wvMat);
    % %     spires=load(SPIReSMat);
    % %     outProj.ProjectionStructure=spires.out.hdr.ProjectionStructure;
    % %     outProj.RasterReference=spires.out.hdr.RasterReference;
    outProj.ProjectionStructure=productFSCA.hdr.ProjectionStructure;
    outProj.RasterReference=productFSCA.hdr.RasterReference;  
    [wvFsca, coarseR, M, newR]=doCoarsen(wvTruth,outProj,wvVal(2),rFlag,targetRes);
    wvFill=doCoarsen(wvTruth,outProj,wvVal(1),rFlag,targetRes);
    wvSnowFree=doCoarsen(wvTruth,outProj,wvVal(3),rFlag,targetRes);
    wvFill=wvFill>0.1 | (isnan(wvSnowFree)&isnan(wvFsca));%fill if more than 10% is fill in coarse pixel
else
    wvTruth.snowmaskR=wvTruth.RefMatrix;
    wvTruth.ProjectionStructure=geotiff2mstruct(wvTruth.geoinfo);
    outProj=SPIReSMat;
    [wvFsca, coarseR, M, newR]=doCoarsen(wvTruth,outProj,[],rFlag,targetRes);
    wvFill=[];
end
end

function [coarseWV, coarseR, M, newR]=doCoarsen(W,outProj,V,rFlag,targetRes)
%wvVal - value in wv mask to coarsen (fill or fsca)
%targetRes in meters
if~rFlag
    M=single(W.snowmask==V);
    origSz=size(M);
else
    M=W.X;
    origSz=size(M);
end

N=floor(log2(targetRes/W.snowmaskR(2,1)));
for i=1:N
    M=impyramid(M,'reduce');
end
[x11, y11]=pix2map(W.snowmaskR,1,1);
dx=W.snowmaskR(2,1);
dy=W.snowmaskR(1,2);
adjustment = origSz./size(M);
newdy = dy*adjustment(1);
newdx = dx*adjustment(2);
x11 = x11+(newdx-dx);
y11 = y11+(newdy-dy);
dx = newdx;
dy = newdy;
newR = makerefmat(x11,y11,dx,dy);
[coarseWV,coarseR]=rasterReprojection(M,newR,W.ProjectionStructure,...
    outProj.ProjectionStructure,'rasterref',outProj.RasterReference);
end