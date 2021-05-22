function wvraw2clusters(wvDir,saveDir,rows,cols,saveDir2,whichK,makePSFlag)
%WVRAW2CLUSTERS
% take raw 8 band wv data (wv2 or wv3) and process through to individual
% cluster masks to be used for manual cluster ID.
%whichK ="high","optimal" or numeric. best to seletc objectivly
%% pansharpen
pansharpDir=fullfile(saveDir,'panSharp');
if makePSFlag
pansharpenWV(pansharpDir,wvDir,rows,cols)
end
%% sample imageset (big, smalls, sample)
tempDir=fullfile(saveDir,'temp');
wvSamples(pansharpDir,tempDir);
%% evaluate a matrix of clustering solutions
%%%%wvEvalClusters(tempDir)
%% generate final kmeans cluser centers from 5 million pixel subsample
C=wvCalcCentroids(tempDir,saveDir2,whichK);
%% apply centroids to 5 random 5000x5000 pixel regions and mask each class
tempImgDir=fullfile(tempDir,'tempImgs');
printClusters(C,tempImgDir,tempDir)
printClusters2(C,pansharpDir,tempDir)
end