function [C]=wvCalcCentroids(tempDir,saveDir2,whichK)
%inputs
%   savedir2 - backup (dropfolder so centorids (small data volume) are safe
if ~isfolder(saveDir2)
    mkdir(saveDir2)
end

data=load(fullfile(tempDir,'sample.mat'));


if isnumeric(whichK)
    numClasses=whichK;
else
    eva=load(fullfile(tempDir,'eval.mat'));
    
    switch whichK
        case 'highK'
            numClasses=eva.highK;
        case'optimalK'
            numClasses=eva.OptimalK;
            
    end
end

distance = 'sqeuclidean';
stream = RandStream('mlfg6331_64');  % Random number stream
options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);
maxItr=1000;
[~, C]=kmeans(data.X,numClasses,'Options',options,'Display','iter', 'MaxIter',maxItr,'Distance',distance);
save(fullfile(tempDir,'centroids.mat'),'C')
save(fullfile(saveDir2,'centroids.mat'),'C')
end