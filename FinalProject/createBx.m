function B = createBx( t0, dimX, width )
    numPoints = length(t0);   
    
    Bc = zeros(numPoints, 1);
    Bt1Min = zeros(numPoints, 1);
    Bt2Min = zeros(numPoints, 1);
    Bt1Max = zeros(numPoints, 1);
    Bt2Max = zeros(numPoints, 1);
    
    for i = 1: numPoints
        Bt1Min(i) = min(t0(i).x + width, dimX); 
        Bt2Min(i) = min(t0(i).x + width, dimX);
        Bt1Max(i) = -1 * max(t0(i).x - width, 1);
        Bt2Max(i) = -1 * max(t0(i).x - width, 1);
    end
    
    B = [Bc; Bt1Min; Bt2Min; Bt1Max; Bt2Max];

end

