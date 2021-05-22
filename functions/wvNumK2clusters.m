function wvNumK2clusters(saveDir,saveDir2,whichK)
%WVRAW2CLUSTERS
% take raw 8 band wv data (wv2 or wv3) and process through to individual
% cluster masks to be used for manual cluster ID.

%% sample imageset (big, smalls, sample)
tempDir=fullfile(saveDir,'temp');
C=wvCalcCentroids(tempDir,saveDir2,whichK);
%% apply centroids to 5 random 5000x5000 pixel regions and mask each class
tempImgDir=fullfile(tempDir,'tempImgs');
fprintf('loading Big \n')
load(fullfile(tempDir,'Big.mat'),'Big')
fprintf('Big Loaded \n')
printClusters(Big,C,tempImgDir)
end