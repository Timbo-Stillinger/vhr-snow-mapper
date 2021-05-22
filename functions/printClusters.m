function printClusters(C,saveDir,loadDir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ~isfolder(saveDir)
    mkdir(saveDir)
end
rng('default');  % For reproducibility
szC=size(C);
for j=1:10
    load(fullfile(loadDir,['subscene' num2str(j) '.mat']),'subScene')   
    tempT=subScene;
    tempI=applyCentroids(tempT,C);
    for k=1:szC(1)
        snowImg = labeloverlay(tempT(:,:,[4 2 1]),tempI==k);
        imwrite(snowImg,fullfile(saveDir,['subScene_' num2str(j) '_class_' num2str(k) '.jpg']))
    end
end
end

