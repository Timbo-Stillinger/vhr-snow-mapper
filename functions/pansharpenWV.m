function pansharpenWV(saveDir,dirWV,rows,cols)
if ~isfolder(saveDir)
    mkdir(saveDir)
end
% pansharpen
tic
%find the TIF files
mD=dir(fullfile(dirWV,'*MUL'));
pD=dir(fullfile(dirWV,'*PAN'));

%only the Row and Cols I want (not clouds)
if ~isempty(rows) && ~isempty(cols)
    
    dM=dir(fullfile(mD.folder,mD.name,'*R*C*.TIF'));
    
    rw=cellfun(@(x) strcat('R',num2str(x)),num2cell(rows),'UniformOutput',false);
    cl=cellfun(@(x) strcat('C',num2str(x)),num2cell(cols),'UniformOutput',false);
    
    h=1;
    for i = 1:length(dM)
        for j = 1:length(cl)
            for k = 1:length(rw)
                thisTile=[rw{k},cl{j}];
                if  contains(dM(i).name,thisTile)
                    filenames{h}=fullfile(dM(i).folder,dM(i).name); %#ok<AGROW>
                    h = h+1;
                end
            end
        end
    end
else
    
    folderPath=fullfile(mD.folder,mD.name);
    filenames= listFilenames(folderPath,'*R*C*.TIF');
    
end



%pansharpening parameters
scale=4;
sensor='WV2';
tag=[];

%parfor max workers (dont override memory)
M=4;
parfor (i=1:length(filenames),M) 
%for i=1:length(filenames)
    tic
    %multispectral file
    mfname=filenames{i};
    X=geotiffread(mfname);
    assert(isa(X,'uint8'),'worldview data must be uint8')
    fprintf('starting %s\n',mfname)
    
    %panchromatic file
    [sIdx,eIdx]=regexp(mfname, regexptranslate('wildcard', 'R??C*'));
    if isempty(sIdx)
        [sIdx,eIdx]=regexp(mfname, regexptranslate('wildcard', 'R?C*'));
    end
    wvIdx = mfname(sIdx:eIdx);
    dP=dir(fullfile(pD.folder,pD.name,['*' wvIdx]));
    pfname=fullfile(dP.folder,dP.name);
    xP=geotiffread(pfname);
    assert(isa(xP,'uint8'),'worldview data must be uint8')
    
    %pansharpen with Gram-Schmidt (GS) mode 2 algorithm with Generalized Laplacian Pyramid (GLP) decomposition
    X = imresize(X,scale,'Method','bicubic');%upsample
    szM=size(X);
    szP=size(xP);
    
    %assumme pan band is right size-chop/grow multispectral to fit -hack
    if szM(1)~=szP(1)||szM(2)~=szP(2)
        if abs(szM(1)-szP(1))<4 && abs(szM(2)-szP(2))<4
            
            if szM(1)>szP(1)
                X(szP(1)+1:szM(1),:,:)=[];
            elseif szM(1)<szP(1)
                X(szM(1)+1:szP(1),:,:)=X(szM(1),:,:);
            end
            
            if szM(2)>szP(2)
                X(:,szP(2)+1:szM(2),:)=[];
            elseif szM(2)<szP(2)
                X(:,szM(2)+1:szP(2),:)=X(:,szM(2),:);
            end
        else
            warning('upsampled multispectral image size dosent match pan band image size')
            fprintf('unable to process %s\n',mfname)
            continue
        end
    end
    
    X = uint8(GS2_GLP(X,xP,scale,sensor,tag));
    
    %save as band 2- band 7 + panBand as last band.
    X(:,:,[1 8])=[];
    X=cat(3,X,xP);
    xP=[];%free memory
    geoinfo = geotiffinfo(pfname);
    RefMatrix=geoinfo.RefMatrix;
    
    [~,name,~] = fileparts(filenames{i});
    
    fname_panM=fullfile(saveDir,strcat('panSharp_',name,'.mat'));
    % % %     geotiffwrite(fnameSM,xPSM,R,'GeoKeyDirectoryTag',key);%,'TiffTags',tags)
    readME=('warning: band 1 and band 8 outside spectral range for pan sharpening and discarded.. this file is worldview mxnx[band2,3,4,5,6,7,panBand]');
    savePanSharp(X,geoinfo,RefMatrix,fname_panM,readME)
end
fprintf('pansharping done...\n')
end