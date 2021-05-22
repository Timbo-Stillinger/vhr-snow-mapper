function wvEvalClusters(smallDir)
%WVEVALCLUSTERS Summary of this function goes here
%output
%   evaltbl.mat

numEvals=11;
evals=5:15;
filenames=listFilenames(smallDir,'small*.mat');
CriterionValues=zeros(length(filenames)+1,numEvals);
OptimalK=zeros(size(length(filenames)+1,1));

%keep track of # of clusters
CriterionValues(1,:)=evals;
OptimalK(1)=nan;

stream = RandStream('mlfg6331_64');  %repeatable
options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);

for k = 1:length(filenames)
    thisEval=k+1;
    sml=load(filenames{k});
    X=sml.small;
    clust = zeros(size(X,1),15);
    parfor i=evals     
        clust(:,i) = kmeans(X,i,'Options',options,'emptyaction','singleton',...
            'replicate',5);
    end
    clust(:,1:4)=[];
    eva = evalclusters(X,clust,'CalinskiHarabasz');
    CriterionValues(thisEval,:)=eva.CriterionValues;
    OptimalK(thisEval)=eva.OptimalK;
        
    tempHK=round(eva.CriterionValues,3,'significant');
    [M,~]=max(tempHK);
    eqK=find(tempHK==M);
    highK(thisEval)=evals(max(eqK));
    
    clear sml X eva tempHK eqK
end
OptimalK=OptimalK';
highK=highK';
evaTbl=table(CriterionValues,OptimalK,highK);
OptimalK=max(OptimalK);
highK=max(highK);
save(fullfile(smallDir,'eval.mat'),'evaTbl','OptimalK','highK')
end

