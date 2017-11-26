function weights = meanshiftWeights(X, q_model, p_test, bins)
    weights = zeros(size(X, 1), 1);
    for row = 1:size(X)
        % determine the bin of this pixel
        bin = floor(X(row, 3:5)/(256/bins)) + 1;
        q_u = q_model(bin(1), bin(2), bin(3));
        p_u = p_test(bin(1), bin(2), bin(3));
        if (p_u ~= 0) 
            weights(row) = sqrt(q_u / p_u);
        end
    end
end