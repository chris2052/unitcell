function [] = symInTxt(filename, f)
%SYMINTXT Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(filename, 'wt');
fprintf(fid, '%s\n', char(f));
fclose(fid);
end

