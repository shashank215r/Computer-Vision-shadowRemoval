function finalMask = computeFinalMask( mask, modelsX, modelsY, t0, width )
    finalMask = mask;
    dimY = size(mask,1);
    dimX = size(mask,2);
    
    for i = 1: length(t0)
        t2x = modelsX(i).t2;
        yVal = t0(i).y;
        for j = -width : 1 : width
            %getting starting x to move
            x = min(dimX-1, max(t0(i).x + j, 1));
            if(mask(yVal, x) == 0 && mask(yVal, x+1) == 1)
                for k = t2x.x : x
                    finalMask(yVal, k) = 1;
                end
            elseif(mask(yVal, x) == 1 && mask(yVal, x+1) == 0)
                for k = x : t2x.x
                    finalMask(yVal, k) = 1;
                end
            end
            
        end
        
        t2y = modelsY(i).t2;
        xVal = t0(i).x;
        for j = -width : 1 : width
            %getting starting y to move
            y = min(dimY-1, max(t0(i).y + j, 1));
            if(mask(y, xVal) == 0 && mask(y+1, xVal) == 1)
                for k = t2y.y : y
                    finalMask(k, xVal) = 1;
                end
            elseif(mask(y, xVal) == 1 && mask(y+1, xVal) == 0)
                for k = y : t2y.y
                    finalMask(k, xVal) = 1;
                end
            end
            
        end
    end


end


