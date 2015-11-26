%%
 % b.Area = c/len;
 % b.MajorAxisLength = d/len;
 % b.MinorAxisLength = e/len;
 % b.Solidity = f/len;
 % b.Perimeter = g/len;
%%
function [distance] = euclid(a, b)
    inner = (a.Area - b.Area)^2;
    inner = inner + (a.MajorAxisLength - b.MajorAxisLength)^2;
    inner = inner + (a.MinorAxisLength - b.MinorAxisLength)^2;
    inner = inner + (a.Solidity - b.Solidity)^2;
    inner = inner + (a.Perimeter - b.Perimeter)^2;
    
    distance = sqrt(inner);
end