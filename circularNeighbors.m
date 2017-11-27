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
                % Bicubic interpolation can provide values outside original
                % range, so need to threshold just to be sure
                img1 = max([min([img(r,c,1), 255.0]), 0.1]);
                img2 = max([min([img(r,c,2), 255.0]), 0.1]);
                img3 = max([min([img(r,c,3), 255.0]), 0.1]);
                result(end + 1, :) = [c, r, img1, img2, img3];
            end
        end
    end
    
end