% Function that plot the matrix with the color col1. x is the line of the
% matrix, y the number of colonnes

function y = visualisationShared(matrix, matrix2, x,y, z, col1, nameFig, varargin)

%tall = size(nameFig,2);
for i=1:x
    for j=1:y
        meanV(i,j) = matrix(y*(i-1)+j);
        stdV(i,j) = matrix2(y*(i-1)+j);
    end
end
shaded = 0;
vectX = [1:1:size(meanV(i,:),2)];
if(~isempty(varargin))
    for i=1:length(varargin)
        if(strcmp(varargin{i},'vecX')==1)
            vectX = varargin{i+1};
        elseif(strcmp(varargin{i},'shaded')==1)
            shaded=1;
            sh = varargin{i+1};
        end
    end
end


if(isa(col1, 'char'))
    %for i=1:x
     i=z;
     if(shaded==1)
       
       shadedErrorBar(vectX',meanV(i,:),stdV(i,:),col1, sh); hold on;
     else
       shadedErrorBar(vectX',meanV(i,:),stdV(i,:),col1); hold on;
     end
else
    %for i=1:x 
     i=z;
     if(shaded==1)
        shadedErrorBar(vectX',meanV(i,:),stdV(i,:), {'color', col1}, sh); hold on;
     else 
        shadedErrorBar(vectX',meanV(i,:),stdV(i,:), {'color', col1});hold on;
     end
    %end
end
 y = nameFig;
end