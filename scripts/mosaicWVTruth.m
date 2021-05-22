% mosaic individual WV tiles

tic
saveDir='';
d=dir(fullfile(saveDir,'*snowmask.tif'));
filenames=cell(length(d),1);
for j=1:length(d)
    filenames{j}=fullfile(saveDir,d(j).name);
end
toc

tic
[snowmask,snowmaskR]=mosaicTiles(filenames,'tif','uint8');
toc

save(fullfile(saveDir,'snowmaskMosaicWV.mat'),'snowmask','snowmaskR','-v7.3');
toc