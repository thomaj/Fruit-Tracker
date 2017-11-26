% The main file for testing the project
VIDEO_FILE = 'Videos/IMG_1083.mov';

v = VideoReader(VIDEO_FILE);

firstFrame = double(readFrame(v));
% firstFrame = imresize(firstFrame, 0.4);
whos firstFrame



% Mean-shift tracking
EPSILON = 0.5;
MAX_ITERATIONS = 50;
radius = 22;
numberOfBins = 16;
startX = 688;%671;
startY = 369;%343;

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

% Take the first five frames and create a background model
firstFrames = zeros(0,0,0,0);
for i=1:5
   if (hasFrame(v))
       firstFrames(:,:,:,end+1) = double(readFrame(v));
   end
end

backgroundModel = createBackgroundModel(firstFrames);

previousFrame = firstFrame;
while hasFrame(v)
    currentFrame = double(readFrame(v));
    
    % Perform background subtraction
    currentFrame = checkAgainstBackgroundModel(currentFrame, backgroundModel);
    
    startPosX = posX;
    startPosY = posY;
    
    % Now perform mean-shift tracking to see where the target is now

    dist = 10;
    iteration = 0;
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
    
    
    imagesc(uint8(currentFrame));
    hold on;
    viscircles([posX, posY],radius);
    hold off;
    pause(0.1);
    
    % We have now tracked the target, so move to next frame
    % NOTE: will only do following line if we update the q_model
    previousFrame = currentFrame;
    
    
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