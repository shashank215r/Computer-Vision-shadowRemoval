function [coeff] = solveCubic(t1, t2, c)
    X = [t1^3, t1^2, t1, 1; 
         t2^3, t2^2, t2, 1;
         3*t1^2, 2*t1, 1, 0;
         3*t2^2, 2*t2, 1, 0;];
    Y = [c;0;0;0];
    	
    coeff = pinv(X)*Y;
%    coeff = A\b;
end