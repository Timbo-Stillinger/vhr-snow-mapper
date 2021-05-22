%addpath(genpath('/raid/sandbox/snowhydro/tstillinger/Dropbox/MATLAB/tools/PansharpeningToolver1.3'))
%works with 2020 file packaging convention for Worldview 2/3 datasets

%example filename and directory structure
wvID='Mammoth2017_012279229_10_0';
mainDir='/raid/scratch/scratch-snow/wv';
homDir=fullfile(mainDir,wvID);
svD=fullfile(mainDir,'processed',wvID);
svD2=fullfile(mainDir,'wvCentroids',wvID);

thisDir=dir(fullfile(homDir,'**/**/*_PAN'));
dataDate=dir(fullfile(thisDir(1).folder,thisDir(1).name,'*README.TXT'));
k=strfind(dataDate(1).name,'-');
saveF=dataDate(1).name(1:k(1)-1);
saveDir=fullfile(svD,saveF);
homDir=thisDir(1).folder;
saveDir2=fullfile(svD2,saveF);
rows=[];
cols=[];

makePSFlag=true;
rows=[];
cols=[];
whichK=30;
tic
wvraw2clusters(homDir,saveDir,rows,cols,saveDir2,whichK,makePSFlag)
toc