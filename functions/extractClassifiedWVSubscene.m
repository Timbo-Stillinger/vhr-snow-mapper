function [subScene,I] = extractClassifiedWVSubscene(Big,sceneSize,C)
%EXTRACTWVSUBSCENE Summary of this function goes here
%   Detailed explanation goes here
[nR,nC,~]=size(Big);
imgC=randi([1,nC-sceneSize],1,1);
imgR=randi([1,nR-sceneSize],1,1);
subScene=Big(imgR:imgR+sceneSize-1,imgC:imgC+sceneSize-1,:);
[I] = applyCentroids(subScene,C);
end