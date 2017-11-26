function score = bhattacharyyaCoefficient(model, candidate)
    flattenedModel = reshape(model, 1, []);
    flattenedCandidate = reshape(candidate, 1, []);
    sqrtModel = sqrt(flattenedModel);
    sqrtCandidate = sqrt(flattenedCandidate);
    
    score = sqrtModel * sqrtCandidate';
end