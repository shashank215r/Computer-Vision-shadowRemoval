function outputImageText = Main()
%function outputImageText = Main(orginalImage, maskedImage)

im = imread('images/DSC_0400.jpg');
im_mask = imread('images/DSC_0400.png');
im = im2double(im);
meanval = 0;
for layer=1:3

     I = im(:,:,layer);
     meanval(1, layer) = mean(I(:));
     Illum = log(I+1);

     boundary = traceBoundary(im_mask);
     
     [m_lx,m_ly]=getIlluminationModel(boundary,Illum);

end

end