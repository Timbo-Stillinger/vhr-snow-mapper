%addpath(genpath('/raid/sandbox/snowhydro/tstillinger/Dropbox/MATLAB/tools/PansharpeningToolver1.3'))
%works with 2020 file packaging convention for Worldview 2/3 datasets

%save all generated material in a directory at this location (recommened
%10X avalible storage space compared to original worldview file size)
svD='';

%save the centorids file (very small) in a safe place that might have better
%backup - this files inables skipping the computations in the first part of
%the algorithm 
svD2='';

%location where worldview data is stored
homeDir='';

%pansharpen the data
makePSFlag=true;

%set number  of clusters to generate
whichK=30;

wvF=dir(homeDir);
wvF=wvF(~ismember({wvF.name},{'.','..'}));
idx=[wvF.isdir];

for i = 1:length(wvF)
    if idx(i)
        
        thisDir=dir(fullfile(homeDir,wvF(i).name,'**/**/*_PAN'));
        dataDate=dir(fullfile(thisDir(1).folder,thisDir(1).name,'*README.TXT'));
        k=strfind(dataDate(1).name,'-');
        saveF=dataDate(1).name(1:k(1)-1);
        saveDir=fullfile(svD,saveF);
        wvDir=thisDir(1).folder;
        saveDir2=fullfile(svD2,saveF);
        rows=[];
        cols=[];
        wvraw2clusters(wvDir,saveDir,rows,cols,saveDir2,whichK,makePSFlag)
    end
end