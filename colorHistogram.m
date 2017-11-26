function hist = colorHistogram(X, bins, x, y, h)
    hist = zeros(bins,bins,bins);
    for row = 1:size(X, 1)
       distanceFromCenter = X(row, 1:2) - [x, y];
       sqDistFromCenter = distanceFromCenter.^2;
       numerator = sqrt(sum(sqDistFromCenter));
       r = (numerator / h)^2;
       k = 1 - r;
       if (r >= 1)
           k = 0;
       end
       bin = floor(X(row, 3:5)/(256/bins)) + 1;
       hist(bin(1), bin(2), bin(3)) = hist(bin(1), bin(2), bin(3)) + k;
       
    end
    
    total = sum(sum(sum(hist)));
    hist = hist / total;
    
    
end