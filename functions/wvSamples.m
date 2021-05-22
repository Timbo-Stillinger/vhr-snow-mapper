function wvSamples(pansharpDir,saveDir)
%WVSAMPLES Summary of this function goes here
%input
%   pansharpDir-folder with pansharpened wvTiles i.e ../wv/processed/date/panSharp
%   saveDir-folder to save output to i.e. ../wv/processed/date/temp
%output
%   big - very large varaiable (so dont have to reload later)
%   big.mat
%   small1.mat.......small10.mat
%   sample.mat
if ~isfolder(saveDir)
    mkdir(saveDir)
end
%% big.mat
filenames=listFilenames(pansharpDir,'*.mat');
varName ='X';
[Big,~]=mosaicTiles(filenames,'mat','uint8',varName);
toc
% fprintf('MOSAIC DONE: saving Big.mat.... \n')
% save(fullfile(saveDir,'Big.mat'),'Big','BigRmap','-v7.3');
% fprintf('Save Complete \n')

%% small*.mat
[nR,nC,nD]=size(Big);
BigTbl=reshape(Big,nR*nC,nD);
rng('default');  % For reproducibility
%1 million points 10x replicates for determining optimum number of clusters
for j = 1:10
    k=1e6; %round(min(round(nR*nC)*0.0001,1e6));
    small=datasample(BigTbl,k);
    small=single(small);
    small(small==0)=NaN;
    save(fullfile(saveDir,['small' num2str(j) '.mat']),'small')
end

%% sample.mat - 5million points for calculating cluster centroids
X=datasample(BigTbl,5e6);
X=single(X);
X(X==0)=NaN;
save(fullfile(saveDir,'sample.mat'),'X')

%% printClusters subscenes
rng('default');  % For reproducibility
sceneSize=5000;
for j=1:10
    [nR,nC,~]=size(Big);
    imgC=randi([1,nC-sceneSize],1,1);
    imgR=randi([1,nR-sceneSize],1,1);
    subScene=Big(imgR:imgR+sceneSize-1,imgC:imgC+sceneSize-1,:);    
    save(fullfile(saveDir,['subscene' num2str(j) '.mat']),'subScene')   
end