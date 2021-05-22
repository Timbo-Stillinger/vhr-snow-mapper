function applyCentroids2Dir(C,wv_dir,outdir,snowClasses,snowFreeDir,browseDir)
%apply centroids to create snow / snow free mask, and include NaN
%saved mask output key:
% 0 - fill pixel
% 1 - snow covered pixel
% 2 - snow free pixel
% 255 - (intmax('uint8')) - NaN - fill pixel. - for WV data wv(wv==0)=NaN

%%%MAKE SURE FILL PIXELS ARE NOT MASKED
d=dir(fullfile(wv_dir,'*R*C*'));
parfor i=1:length(d)
    fname=fullfile(d(i).folder,d(i).name);
    S = load(fname)
    X=S.X;
    info=S.geoinfo;
    
    [I] = applyCentroids(X,C);
    
    
    %mask out known snow free areas
 if ~isempty(snowFreeDir)
    sfD=dir(fullfile(snowFreeDir,['notSnow_',d(i).name]))
    sfName=fullfile(sfD(1).folder,sfD(1).name);
    SF = load(sfName);
    snowFree=SF.notSnow;
 else 
     snowFree=false(size(I));
 end
    
   %initalize as fill
   mask=uint8(zeros(size(I)));
   snow=false(size(I));
   for j = 1:length(snowClasses)
   snow(I==snowClasses(j))=true;
   end
   
% %    %clean up
% %    SE=strel('square',3);
% %    snow=imerode(snow,SE);
% %    snow=imdilate(snow,SE);
% %    snow=imdilate(snow,SE);

   
   mask(snow)=1;
   %retain fill pixel info
   fill=isnan(I);
   snowFree=snowFree|(~fill&mask~=1);
   mask(snowFree)=2;
   
   savename=fullfile(outdir,...
       [d(i).name(1:end-4),'_snowmask','.tif']);
geotiffwrite(savename,mask,info.RefMatrix,...
    'GeoKeyDirectoryTag',...
    info.GeoTIFFTags.GeoKeyDirectoryTag);

%print browse figure side by side rgb + labeled rgb
RGB=X(:,:,[4 2 1]);
snowImg = labeloverlay(RGB,mask==1);
browseImg = [RGB,snowImg;imoverlay(zeros(size(RGB)),mask==2),imoverlay(zeros(size(RGB)),mask==1)];
browseImg=imresize(browseImg,0.1,'method','nearest');
imwrite(browseImg,fullfile(browseDir,...
       [d(i).name(1:end-8),'_BROWSE','.jpg']));
fprintf('done w/ %s\n',savename);
end