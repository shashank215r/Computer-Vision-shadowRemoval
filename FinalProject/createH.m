function H = createH(lambda, gamma, numPoints)
    Hc =  createPartH(lambda, gamma, numPoints);
    Ht1 =  createPartH(lambda, 1 - gamma, numPoints);
    Ht2 =  createPartH(lambda, 1 - gamma, numPoints);
    zeroMatrix = zeros(numPoints);
    H = [Hc zeroMatrix zeroMatrix; zeroMatrix Ht1 zeroMatrix; zeroMatrix zeroMatrix Ht2];
    H = 2 * H;




function partH = createPartH(lambda, gamma, numPoints)
    for i = 1 : numPoints
        if(i > 1)
            partH(i-1,i) = -2*gamma*lambda;
            partH(i,i-1) = -2*gamma*lambda;
        end
        partH(i,i) = gamma *(1+ 4*lambda);
    end
     
