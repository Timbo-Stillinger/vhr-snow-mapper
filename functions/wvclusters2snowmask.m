function wvclusters2snowmask(C,snowClasses,panSharpDir,outDir,snowFreeDir,dateWV)
%WVCENTROIDS2SNOWMASK Summary of this function goes here
%classify all tiles as snow/snow free/fill -first time WV touched for projection info
if ~isfolder(outDir)
    mkdir(outDir)
end
tempDir=fullfile(outDir,'tempMasks');
if ~isfolder(tempDir)
    mkdir(tempDir)
end

maskDir=fullfile(tempDir,'masks');
if ~isfolder(maskDir)
    mkdir(maskDir)
end
browseDir=fullfile(tempDir,'browseImgs');
if ~isfolder(browseDir)
    mkdir(browseDir)
end

applyCentroids2Dir(C,panSharpDir,maskDir,snowClasses,snowFreeDir,browseDir)

d=dir(fullfile(maskDir,'*snowmask.tif'));
filenames=cell(length(d),1);
for j=1:length(d)
    filenames{j}=fullfile(maskDir,d(j).name);
end

[snowmask,snowmaskR]=mosaicTiles(filenames,'tif','uint8');


%geotiff
geoinfo=geotiffinfo(filenames{1});
savename=fullfile(outDir,[dateWV '_snowmaskMosaicWV.tif']);
geotiffwrite(savename,snowmask,snowmaskR,...
    'GeoKeyDirectoryTag',...
    geoinfo.GeoTIFFTags.GeoKeyDirectoryTag);


ProjectionStructure=geotiff2mstruct(geoinfo);

%mat file
save(fullfile(outDir,[dateWV '_snowmaskMosaicWV.mat']),...
    'snowmask','snowmaskR','ProjectionStructure','-v7.3');

%browse img
imwrite(imresize(snowmask,0.01,'method','nearest')==1,fullfile(outDir,'snowmaskMosaic_BROWSE.jpg'));
fprintf('done w/ snow mask mosaic \n');
end

