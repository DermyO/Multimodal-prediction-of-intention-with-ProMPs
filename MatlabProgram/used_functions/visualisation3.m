% Function that plot the matrix with the color col1. 
%x is the line of the matrix
% y the number of colonnes
% choice: ? maybe the data we draw ?
%col1: the selected color
%nameFig: the name of the figure
%varargin : ? axe y ?
function y = visualisation3(matrix, x,y, col1, nameFig, varargin)

tall = size(nameFig,2);
for i=1:x
    for j=1:y
        val(i,j) = matrix(y*(i-1)+j);
    end
end

if (nargin >6) 
    if(isa(col1, 'char'))
         
           nameFig(tall + 1) = plot3(varargin{1},val(1,:),val(2,:), col1,'linewidth',1); hold on;
    else
         
          nameFig(tall + 1) = plot3(varargin{1},val(1,:),val(2,:), 'Color', col1,'linewidth',1); hold on;
    end
    y = nameFig;
else
    if(isa(col1, 'char'))
         
           nameFig(tall + 1) = plot3( 1:size(val(1,:),2), val(1,:),val(2,:), col1,'linewidth',1); hold on;
    else
         
          nameFig(tall + 1) = plot3( 1:size(val(1,:),2), val(1,:),val(2,:), 'Color', col1,'linewidth',1); hold on;
    end
     y = nameFig;
    end
end