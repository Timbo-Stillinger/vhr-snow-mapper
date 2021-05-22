function [Big, BigRmap] = mosaicTiles(filenames,itype,otype,varargin)

%INPUT
% filenames - cell array of filenames for tiles, must have RefMatrix
% RefMatrix must be in a global coordinate system, e.g. not diff UTM zones
% itype - input type string : 'mat','tif', 'flt' or 'h5'
% otype - data type for output image, e.g. 'uint8'
% optional input:
% for 'mat' -  variable name, for h5 'location' followed by 'read_loc',ie
% start and count

%OUTPUT
% Big mosaiced image
% BigRmap  - referencing matrix for output grid

%fillval is min of datatype
if ~isempty(regexp(otype,'int','once'))
    fillval=intmin(otype);
else
    fillval=NaN;
end
if nargin>=4
    varname=varargin{1};
    if nargin>5
        start_loc=varargin{2};
        count_loc=varargin{3};
    end
end

RefMatrices=zeros(length(filenames),3,2);
sizes=zeros(length(filenames),2);
lr=zeros(length(filenames),2);
first=true;
for t=1:length(filenames)
    if strcmp(itype,'tif')
        if first
            a=geotiffread(filenames{t});
            sz3=size(a,3);
            first=false;
        end
        info=geotiffinfo(filenames{t});
        RefMatrices(t,:,:)=info.RefMatrix;
        sz=[info.Height info.Width sz3];
        sizes(t,:)=sz(1:2);
    elseif strcmp(itype,'flt') %grid float
        [a,R]=arcgridread(filenames{t});
        sz=[size(a,1) size(a,2) size(a,3)];
        if length(R)==1 %R is a rasterref
            RefMatrices(t,:,:)=RasterRef2RefMat(R);
        elseif length(R)==3 % R is a RefMatrix
            RefMatrices(t,:,:)=R;
        end
        sizes(t,:)=sz(1:2);
    elseif strcmp(itype,'mat')
        load(filenames{t});
        RefMatrices(t,:,:)=RefMatrix;
        a=eval(varname);
        sz=[size(a,1) size(a,2) size(a,3)];
        sizes(t,:)=sz(1:2);
    elseif strcmp(itype,'h5')
        info=h5info(filenames{t},varname);
        sz=info.Dataspace.Size;
        if length(sz)==2
            sz=[sz 1];
        end
        split_char='/';
        parentloc='';
        locs=strsplit(varname,split_char);
        for j=2:length(locs)-1
            parentloc=[parentloc,split_char,locs{j}];
        end
        hdr = GetCoordinateInfo(filenames{t},parentloc,sz(1:2));
        RefMatrices(t,:,:)=hdr.RefMatrix;
        sizes(t,:)=sz(1:2);
    end
    %list of lower right pixels
    lr(t,:)=[sizes(t,:) 1]*squeeze(RefMatrices(t,:,:));
end

BigRmap=zeros(3,2);
BigRmap(3,1)=min(RefMatrices(:,3,1));
BigRmap(2,1)=RefMatrices(1,2,1); %assume same spacing for all pixels
BigRmap(1,2)=RefMatrices(1,1,2);
BigRmap(3,2)=max(RefMatrices(:,3,2));

%xy coords for lower rt corner
xy=[max(lr(:,1)) min(lr(:,2))];
sBig_=map2pix(BigRmap,xy);
sBig_=round(sBig_);

%assume all pics have same number of channels
if sz(3)==1
    sBig=sBig_;
elseif strcmp(itype,'h5')
    if count_loc(3) == 1
        sBig=sBig_;
    else
        error('3rd entry of count_loc must be 1');
    end
else
    sBig=[sBig_ sz(3)];
end

if strcmp(otype,'logical')
    Big=false(sBig);
else
    Big=zeros(sBig,otype);
    Big(:,:,:)=fillval;
end

for t=1:length(filenames)
    tic
    fprintf('loading %s\n',filenames{t});
    switch itype
        case 'tif'
            tmp=imread(filenames{t});
        case 'flt'
            tmp=arcgridread(filenames{t});
        case 'mat'
            load(filenames{t});
            tmp=eval(varname);
        case 'h5'
            tmp=h5read(filenames{t},varname,start_loc,count_loc);
    end
    %x and y coord of tile
    [x,y]=pix2map(squeeze(RefMatrices(t,:,:)),...
        [1 sizes(t,1)],[1 sizes(t,2)]);
    [row_b,col_b]=map2pix(BigRmap,x,y);
    row_b=round(row_b);
    col_b=round(col_b);
    Big(row_b(1):row_b(2),col_b(1):col_b(2),:)=tmp;
    fprintf('done with %s\n',filenames{t});
    toc
end