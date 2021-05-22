%examples dates
dateWV={'19MAY04185121','19MAY04185139'};

for i= 1:length(dateWV)
    thisDate=dateWV{i};
    saveDir=fullfile('',thisDate);
    saveDir2=fullfile('',thisDate);
    panSharpDir=fullfile(saveDir,'panSharp');
    outDir=fullfile(saveDir,'snowMask');
    snowFreeDir=[];
    
    %load snow classes and centroids
    load(fullfile(saveDir2,'snow.mat'))
    load(fullfile(saveDir2,'centroids.mat'))
    
    wvclusters2snowmask(C,snow,panSharpDir,outDir,snowFreeDir,thisDate);
end