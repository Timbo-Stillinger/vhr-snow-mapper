function printClusters2(C,panSharpDir,outDir)
%WVCENTROIDS2SNOWMASK Summary of this function goes here
%classify all tiles as snow/snow free/fill -first time WV touched for projection info
if ~isfolder(outDir)
    mkdir(outDir)
end
tempDir=fullfile(outDir,'tempClassMasks');
if ~isfolder(tempDir)
    mkdir(tempDir)
end


d=dir(fullfile(panSharpDir,'*R*C*'));
parfor i=1:length(d)
    fname=fullfile(d(i).folder,d(i).name);
    S = load(fname)
    X=S.X;    
    [I] = applyCentroids(X,C);
    
    %initalize as fill
    mask=uint8(zeros(size(I)));
    sz=size(C);
    for j = 1:sz(1)
        
        %print browse figure side by side rgb + labeled rgb
        RGB=X(:,:,[4 2 1]);
        snowImg = labeloverlay(RGB,I==j);
        browseImg = [RGB,snowImg;imoverlay(zeros(size(RGB)),I~=j),imoverlay(zeros(size(RGB)),I==j)];
        browseImg=imresize(browseImg,0.1,'method','nearest');
        imwrite(browseImg,fullfile(tempDir,...
            [d(i).name(1:end-8),'_class_',num2str(j) '_BROWSE','.jpg']));
        
        zoomBrowse = [RGB(end-999:end,1:1000,:),snowImg(end-999:end,1:1000,:)];
        imwrite(zoomBrowse,fullfile(tempDir,...
            ['zoomBrowse_',d(i).name(1:end-8),'_class_',num2str(j) '_BROWSE','.jpg']));
        
    end
    
end
end

