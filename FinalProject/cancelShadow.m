function [cancelGradX, cancelGradY] = cancelShadow( solvedModelX , solvedModelY, gradientX, gradientY, logIm)
    cancelGradX = gradientX;
    cancelGradY = gradientY;
    numPoints = length(solvedModelX);
    
    %cancel shadow effect along xgradients
    for i = 1 : numPoints
        t1 = solvedModelX(i).t1;
        t2 = solvedModelX(i).t2;
        c = solvedModelX(i).c;
        
        if(logIm(t1.y, t1.x) > logIm(t1.y, t2.x))
            temp = t1;
            t1 = t2;
            t2 = temp;
        end
        
        coeff = solveCubic(t1.x, t2.x, c);
        for j = min(t1.x,t2.x) : max(t1.x,t2.x)
            dc = 3 * coeff(1) * (j^2) + 2 * coeff(2) * j + coeff(3);
            cancelGradX(t1.y, j) = gradientX(t1.y, j) - dc;
        end       
    end
    
    %cancel shadow effect along ygradients
    for i = 1 : numPoints
        t1 = solvedModelY(i).t1;
        t2 = solvedModelY(i).t2;
        c = solvedModelY(i).c;
        
        if(logIm(t1.y, t1.x) > logIm(t2.y, t1.x))
            temp = t1;
            t1 = t2;
            t2 = temp;
        end
        
        coeff = solveCubic(t1.y, t2.y, c);
        for j = min(t1.y,t2.y) : max(t1.y,t2.y)
            dc = 3 * coeff(1) * (j^2) + 2 * coeff(2) * j + coeff(3);
            cancelGradY(j, t1.x) = gradientY(j, t1.x) - dc;
        end       
    end
end


