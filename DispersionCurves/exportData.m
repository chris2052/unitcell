function exportData(FileName, xValues, yValues)
%EXPORTDATA Summary of this function goes here
%   Detailed explanation goes here

fileId = fopen(FileName, 'w');
len = size(yValues, 1);
digits = [];
for z = 1:len
    digits = [digits, '%f '];
end
fprintf(fileId, ['%f ',digits, '\n'], [xValues; yValues]);
fclose(fileId);

end

