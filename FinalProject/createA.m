function A = createA( numPoints )
    m = eye(numPoints);
    zeroM = zeros(numPoints);
    A = [m zeroM zeroM; zeroM m zeroM; zeroM zeroM m; zeroM -m zeroM; zeroM zeroM -m];
end

    