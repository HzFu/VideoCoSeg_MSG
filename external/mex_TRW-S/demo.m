% demo

% Example usage:
% 
% Minimize function E(x,y) = Dx(x) + Dy(y) + lambda*[x != y] + Dz(z) + V(y,z) where 
%   x,y \in {0,1,2}, z \in {0,1}
%   Dx(0) = 0, Dx(1) = 1, Dx(2) = 2,
%   Dy(0) = 3, Dy(1) = 4, Dy(2) = 5,
%   lambda = 6,
%   [.] is 1 if it's argument is true, and 0 otherwise.
%   Dz(0) = 7, Dz(1) = 8,
%   V(y,z) = y*y + z

UE{1} = [0, 1, 2];
UE{2} = [3, 4, 5];
UE{3} = [7, 8];

PI = uint32([1, 2; 2, 3]);

PE{1} = [ 0,6,6;6,0,6;6,6,0];
PE{2} = [ 16,17;23,24;32,33];

[L, energy, lower_bound] = vgg_trw_bp(UE, PI, PE);