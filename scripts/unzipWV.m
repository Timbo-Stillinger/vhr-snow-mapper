%batch unzip WV data 
homeDir='';
wvF=dir(fullfile(homeDir,'*.zip'));

for i=1:length(wvF)
unzip(fullfile(wvF(i).folder,wvF(i).name),fullfile(wvF(i).folder,wvF(i).name(1:end-4)));
end