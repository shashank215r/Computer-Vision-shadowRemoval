function f = createF( gamma, optModel, isX )
    numPoints = length(optModel);
    Fc = zeros(numPoints, 1);
    for i = 1 : numPoints
        Fc(i) = -2 * gamma * (optModel(i).c);
    end
    
    Ft1 = zeros(numPoints , 1);
    for i = 1 : numPoints
        if(isX == 1)
            Ft1(i) = -2 * (1 - gamma) * (optModel(i).t1.x);
        else
            Ft1(i) = -2 * (1 - gamma) * (optModel(i).t1.y);
        end
    end
    
    Ft2 = zeros(numPoints , 1);
    for i = 1 : numPoints
        if(isX == 1)
            Ft2(i) = -2 * (1 - gamma) * (optModel(i).t2.x);
        else
            Ft2(i) = -2 * (1 - gamma) * (optModel(i).t2.y);
        end
    end
    
    f = [Fc; Ft1; Ft2];
end



