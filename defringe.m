%% Function to import an image at location FullFileName, then defringe it at the number of levels and save it at OutputFileName
% Levels = how many outer pixels to defringe (level 4 will defringe every pixel)
% BaseColor = background color for non-defringed transparent pixels

function [] = defringe(FullFileName,OutputFileName,Levels,BaseColor)
    [PNGColor,~,PNGTrans] = imread(FullFileName); % Import image

    ImageSize = size(PNGTrans); % Get image size

    % Convert to double for math
    PNGColor = im2double(PNGColor);
    PNGTrans = im2double(PNGTrans);

    PNGTransOrig = PNGTrans; % back up original transparency
    PNGTransPadded = PNGTrans; % Placeholder for transparency matrix with padded values

    % Need to account for diagonals with sqrt(2)

    % skip images without transparency
    if isempty(PNGTrans) == 0
        Transparencies = 1; % Initialize while loop and go through until no fully transparent alphas remain
    else % set it to skip
        Transparencies = [];
    end

    while isempty(Transparencies) == 0

        % Go through full transparencies along 2D image
        for x=1:ImageSize(1) % go through all x coords
            for y=1:ImageSize(2) % go through all y coords
                if PNGTrans(x,y) == 0 % If full transparency, average nearest colors
                    AlphaSum = 0; % Reset alpha sum
                    ColorSum = 0; % Reset weighted color sum
                    OpaqueCount = 0; % Reset number of opaque pixels found (-1 to ignore self pixel)
                    PNGColor(x,y,:) = BaseColor; % Set base color from user

                    for i=-1:1  % go through nearest x offsets
                        for j=-1:1 % go through nearest y offsets
                            if x+i >= 1 && x+i <= ImageSize(1) % dont exceed x bounds
                                if y+j >= 1 && y+j <= ImageSize(2) % dont exceed y bounds

                                    % Scale diagonals as they are "further away"
                                    if abs(i)+abs(j) == 2
                                        Distance = 2;
                                    else
                                        Distance = 1;
                                    end

                                    if PNGTrans(x+i,y+j) > 0 % If opaque pixel found add it to count
                                        OpaqueCount = OpaqueCount + 1/Distance;
                                    end

                                    AlphaSum = AlphaSum + PNGTrans(x+i,y+j)/Distance; % Sum valid alpha value
                                    ColorSum = ColorSum + PNGTrans(x+i,y+j)*PNGColor(x+i,y+j,:)/Distance; % Sum valid color value

                                end
                            end
                        end
                    end

                    if AlphaSum > 0 && Levels ~= 0 % Opaque eighbors found add color to transparent pixel!
                        PNGColor(x,y,:) = ColorSum / AlphaSum; % Weighted color of opaque neighbors
                        PNGTransPadded(x,y) = AlphaSum / OpaqueCount; % Weighted transparency of opaque neighbors
                    end           

                end
            end
        end

        PNGTrans = PNGTransPadded; % Store new padded transparency matrix to go through the rest
        if Levels < 1 % If all levels have been defringed end loop
            Transparencies = []; % Set transparency to empty to end loop if levels are done 
        elseif Levels < 4 % If levels are less than 4 decriment
            Levels = Levels - 1; % Decrement defringe level after each round
        else % If levels set to 4, defringe every pixel
            Transparencies = find(PNGTrans == 0); % Find remaining transparencies
        end
    end

    if isempty(PNGTrans) == 0 % save only if image is has transparency that was potentially updated
        imwrite(PNGColor, OutputFileName, 'Alpha', PNGTransOrig); % save image
    end
end