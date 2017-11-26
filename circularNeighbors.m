function result = circularNeighbors(img, x, y, radius)
    result = zeros(0,5);
    startRow = max([floor(y - radius), 1]);
    endRow =  min([ceil(y + radius), size(img, 1)]);
    startColumn = max([floor(x - radius), 1]);
    endColumn = min([ceil(x + radius), size(img, 2)]);
    
    for r = startRow:endRow
        for c = startColumn:endColumn
            if (((c-x)^2 + (r-y)^2) < radius^2)
                r = round(r);
                c = round(c);
                result(end + 1, :) = [c, r, img(r,c,1), img(r,c,2), img(r,c,3)];
            end
        end
    end
    
end