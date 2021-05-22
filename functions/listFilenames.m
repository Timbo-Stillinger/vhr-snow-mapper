function [filenames] = listFilenames(folderPath,wildcardTxt)
%LISTFILENAMES Summary of this function goes here
%   Detailed explanation goes here
d=dir(fullfile(folderPath,wildcardTxt));

filenames=cell(length(d),1);
for j=1:length(d)
    filenames{j}=fullfile(folderPath,d(j).name);
end

end

