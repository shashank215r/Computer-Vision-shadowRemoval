%function shadow

close all;
im = imread('images/p14_1.jpg');
im_mask = imread('images/p14_1.png');
im = im2double(im);
meanval = zeros(1,3);
for layer=1:3

    I = im(:,:,layer);
    meanval(1, layer) = mean(I(:));
    Illum = log(I+1);

    
    boundary = traceBoundary(im_mask);
    sizeOF = length(boundary);
      
    t0 = struct('x', {}, 'y', {});
    for i = 1:sizeOF
        t0(i).x = boundary(i, 2);
        t0(i).y = boundary(i, 1);
    end
        
    radius = 16;
    [gradX, gradY] = imgradientxy(Illum, 'CentralDifference');
    [m_lx,m_ly]=getIlluminationModel(boundary,Illum,gradX,gradY,radius);

    figure, imshow(I);
    for i = 1:length(m_ly)
        t1 = m_ly(i).t1;
        t2 = m_ly(i).t2;
        hold on;
        plot([t1.x, t2.x], [t1.y, t2.y], 'g', 'LineWidth', 3);
    end

    figure, imshow(I);
    for i = 1:length(m_lx)
        t1 = m_lx(i).t1;
        t2 = m_lx(i).t2;
        hold on;
        plot([t1.x, t2.x], [t1.y, t2.y], 'g', 'LineWidth', 3);
    end
    
    numPoints = sizeOF;
    imMask = im_mask;

    logIm = Illum;
    %fitX
    optX = m_lx;
    optY = m_ly;
    lineWidth = radius/2;
    %-----------------------------------------------------------------------
    % create H, f, A, b for optimum X models and solve the minimization equation
    lambda = 10;
    gamma = 0.9;
    H = createH(lambda, gamma, numPoints);
    f = createF(gamma, optX, 1);
    A = createA(numPoints);
    b = createBx(t0, size(I,2), lineWidth);
%     options = optimoptions('quadprog',...
%     'Algorithm','trust-region-reflective','Display','off');

    %solve for the quadratic minimization problem for X
    outX = quadprog(H,f,A,b);
    outXc = outX(1:numPoints); 
    outXt1 = outX(numPoints + 1 : 2 * numPoints);
    outXt2 = outX(2 * numPoints + 1 : length(outX));
    outXt1 = round(outXt1);
    outXt2 = round(outXt2);
    solvedModelsX = optX;
    for i = 1 : length(optX)
    finalC = outXc(i);
    finalt1x = outXt1(i);
    finalt2x = outXt2(i);

    solvedModelsX(i).c = finalC;

    temp = t0(i);
    temp.x = finalt1x;
    solvedModelsX(i).t1 = temp;

    %since y is same on the horizontal line
    temp.x = finalt2x;
    solvedModelsX(i).t2 = temp;    
    end
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------
    % create H, f, A, b for optimum Y models and solve the minimization equation
    lambda = 10;
    gamma = 0.9;
    H = createH(lambda, gamma, numPoints);
    f = createF(gamma, optY, 0);
    A = createA(numPoints);
    b = createBy(t0, size(I,1), lineWidth);
%     options = optimoptions('quadprog',...
%     'Algorithm','trust-region-reflective','Display','off');

    %solve for the quadratic minimization problem for Y
    outY = quadprog(H,f,A,b);
    outYc = outY(1:numPoints); 
    outYt1 = outY(numPoints + 1 : 2 * numPoints);
    outYt2 = outY(2 * numPoints + 1 : length(outY));
    solvedModelsY = optY;
    outYt1 = round(outYt1);
    outYt2 = round(outYt2);
    for i = 1 : length(optY)
    finalC = outYc(i);
    finalt1y = outYt1(i);
    finalt2y = outYt2(i);

    solvedModelsY(i).c = finalC;

    temp = t0(i);
    temp.y = finalt1y;
    solvedModelsY(i).t1 = temp;

    %since x is same on the vertical line
    temp.y = finalt2y;
    solvedModelsY(i).t2 = temp;    
    end
    %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------
    %Compute Cancelled shadow gradients with the final solved models
    [cancelGradX, cancelGradY] = cancelShadow(solvedModelsX, solvedModelsY, gradX,...
                                    gradY,logIm);
    %--------------------------------------------------------------------------


    %--------------------------------------------------------------------------
    %Compute Cancelled shadow gradients with the final solved models
    finalMask = computeFinalMask(imMask, solvedModelsX, solvedModelsY, t0, lineWidth);
    %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------
    %Compute Texture consistent gradients with the cancelled gradients
    texGradX = calcTexConsistentGrad(cancelGradX, finalMask, t0, lineWidth, 1);
    texGradY = calcTexConsistentGrad(cancelGradY, finalMask, t0, lineWidth, 0);
    %--------------------------------------------------------------------------


    % OGx(:,end) = 0;
    % OGy(end,:) = 0;
    cancelGradX(:,end) = 0;
    cancelGradY(end,:)=0;
    finalCancelledGradX(:,:,layer) = cancelGradX;
    finalCancelledGradY(:,:,layer) = cancelGradY;

    % gtcX(:,end) = 0;
    % gtcY(end,:) = 0;
    
    texGradX(:,end)=0;
    texGradY(end,:)=0;
    finaltexGradX(:,:,layer) = texGradX;
    finaltexGradY(:,:,layer) = texGradY;
end

close all;

display('reconstructing...');
 poissonOn = 1;
 outputImage = ImageRecH(finalCancelledGradX, finalCancelledGradY, meanval, poissonOn);
 outputImageText = ImageRecH(finaltexGradX, finaltexGradY, meanval, poissonOn);

figure; imshow(im, []);
%figure; imshow(outGradX, []);
%figure; imshow(outGradY, []);
%figure; imshow(outGradXtext, []);
%figure; imshow(outGradYtext, []);
figure; imshow(outputImage, []);
figure; imshow(outputImageText, []);




%end


