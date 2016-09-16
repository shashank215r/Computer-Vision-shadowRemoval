function finalGrad = calcTexConsistentGrad( cancelGrad, finalMask, t0, lineWidth, isX )
    % only retain the shadow region in cancelled gradients
    finalGrad = cancelGrad;
    dimY = size(finalMask,1);
    dimX = size(finalMask,2);
    
    shadowGrad = cancelGrad;
    shadowGrad(finalMask == 0) = 0;
    
    meanBefore = mean(shadowGrad(:));
    varBefore = var(shadowGrad(:));
    extent = 4;
    
    numPoints = length(t0);
    
    umbraGrad = zeros(extent*numPoints,1);
    litGrad = zeros(extent*numPoints,1);
    for i = 1 : numPoints
        if(isX == 1)
            %assume as per paper t0-r in umbra and t0+r in lit
            umbraX = max(t0(i).x - lineWidth - extent, 1);
            litX = min(t0(i).x + lineWidth, dimX);
            
            umbraPoints = zeros(extent,1);
            litPoints = zeros(extent,1);
            
            for j = 1 : extent
                umbraPoints(j) = min(umbraX + j, dimX);
                litPoints(j) = min(litX + j, dimX);
            end

            %since in mask umbra is 1 and lit is 0
            if(finalMask(t0(i).y, umbraX) > finalMask(t0(i).y, litX))
                temp = umbraPoints;
                umbraPoints = litPoints;
                litPoints = temp;
            end

            for j = 1 : extent
                umbraGrad(extent*(i-1) +j) = cancelGrad(t0(i).y, umbraPoints(j));
                litGrad(extent*(i-1) +j) = cancelGrad(t0(i).y, litPoints(j));
            end
        else
            %assume as per paper t0-r in umbra and t0+r in lit
            umbraY = max(t0(i).y - lineWidth - extent, 1);
            litY = min(t0(i).y + lineWidth, dimY);
            
            umbraPoints = zeros(extent,1);
            litPoints = zeros(extent,1);
            
            for j = 1 : extent
                umbraPoints(j) = min(umbraY + j, dimY);
                litPoints(j) = min(litY + j, dimY);
            end

            %since in mask umbra is 1 and lit is 0
            if(finalMask(umbraY, t0(i).x) > finalMask(litY, t0(i).x))
                temp = umbraPoints;
                umbraPoints = litPoints;
                litPoints = temp;
            end

            for j = 1 : extent
                umbraGrad(extent*(i-1) +j) = cancelGrad(umbraPoints(j), t0(i).x);
                litGrad(extent*(i-1) +j) = cancelGrad(litPoints(j), t0(i).x);
            end
        end
    end
    
    meanUmbra = mean(umbraGrad);
    meanLit = mean(litGrad);
    varUmbra = var(umbraGrad);
    varLit = var(litGrad);    
    
    meanSe = meanUmbra - meanLit;
    varSe = varUmbra - varLit;
    
    if(varBefore > varSe)
        meanTarget = meanBefore - meanSe;
        varTarget = varBefore - varSe;
    else
        meanTarget = meanSe - meanBefore;
        varTarget = varSe - varBefore;
    end
    
    stdTarget = sqrt(varTarget);
    stdBefore = sqrt(varBefore);
    
    for i = 1: dimY
        for j = 1 : dimX
            if(shadowGrad(i,j) ~= 0)
                finalGrad(i,j) = meanTarget + (shadowGrad(i,j) - meanBefore)*(stdTarget/stdBefore);
            end
        end
    end
end

