function boundary = traceBoundary(imMask)

BW = im2bw(imMask);
dim = size(BW);
% select a col randomly midway through the image
RandomeCol = round(dim(2)/2)-90;
% find the row related to the col in the boundary
RandomRow = min(find(BW(:, RandomeCol)));

boundary = bwtraceboundary(BW, [RandomRow, RandomeCol], 'N');


end