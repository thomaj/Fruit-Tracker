% The main file for testing the project
VIDEO_FILE = 'Videos/Test_Orange_3.mov';

v = VideoReader(VIDEO_FILE);

firstFrame = double(readFrame(v));
% firstFrame = imresize(firstFrame, 0.4);
whos firstFrame



lines = zeros(0, 2);

% Mean-shift tracking
EPSILON = 3.0;
MAX_ITERATIONS = 10;

% Adaptaive Scale
DELTA_H_COEF = 0.1;
radius = 40;
numberOfBins = 16;
startX = 354;%671;
startY = 627;%343;

imagesc(uint8(firstFrame));
hold on;
viscircles([startX, startY],radius);
hold off;
pause;

% Create the target model
X_firstFrame = circularNeighbors(firstFrame, startX, startY, radius);
q_model = colorHistogram(X_firstFrame, numberOfBins, startX, startY, radius);

posX = startX;
posY = startY;

previousFrame = firstFrame;
h_prev = radius;
lines(end + 1, :) = [posX posY];
while hasFrame(v)
    currentFrame = double(readFrame(v));
    
    % Perform background subtraction
    %currentFrame = checkAgainstBackgroundModel(currentFrame, backgroundModel);
    
    startPosX = posX;
    startPosY = posY;
    
    % Now perform mean-shift tracking to see where the target is now
    dist = 10;
    iteration = 0;
    tic
    while (dist > EPSILON && iteration <= MAX_ITERATIONS)
        X_currentFrame = circularNeighbors(currentFrame, posX, posY, radius);
        p_test = colorHistogram(X_currentFrame, numberOfBins, posX, posY, radius);
        w = meanshiftWeights(X_currentFrame, q_model, p_test, numberOfBins);

        weightedPosX = X_currentFrame(:, 1)' * w;
        weightedPosY = X_currentFrame(:, 2)' * w;
        sumOfWeights = sum(w);
        
        posXNext = weightedPosX / sumOfWeights;
        posYNext = weightedPosY / sumOfWeights;

        % Determine how far the point center of circle moved
        dist = distance([posXNext posYNext],[posX posY]);

        posX = posXNext;
        posY = posYNext;

        iteration = iteration + 1;
        %fprintf('iteration: %d\n', iteration);
    end
    toc
    
    % Add the new position to the lines
    lines(end + 1, :) = [posX posY];
    
    
    imagesc(uint8(currentFrame));   % Draw image
    % Draw the circle and the path
    hold on;
    viscircles([posX, posY],radius);
    line(lines(:, 1), lines(:, 2), 'Color', 'b', 'Linewidth', 2);
    hold off;
    drawnow;
    %pause(0.1);
    
    % We have now tracked the target, so move to next frame
    % NOTE: will only do following line if we update the q_model
    %previousFrame = currentFrame;
    
    
end

   
    
  


function model = createBackgroundModel(frames)
    model = mean(frames, 4);
end

function newImage = checkAgainstBackgroundModel(frame, backgroundModel)
    T = 40;
    difference = frame - backgroundModel;
    diffSqrd = difference.^2;
    euclideanDistance = sqrt(sum(diffSqrd, 3));
    red = frame(:,:,1);
    green = frame(:,:,2);
    blue = frame(:,:,3);
    tic
    red(euclideanDistance < T) = 0;
    green(euclideanDistance < T) = 0;
    blue(euclideanDistance < T) = 0;
    toc
    newImage(:,:,1) = red;
    newImage(:,:,2) = green;
    newImage(:,:,3) = blue;
    
end


    

function dist = distance(point1, point2)
    dist = sqrt((point2(2)-point1(2))^2+(point2(1)-point1(1))^2);
end