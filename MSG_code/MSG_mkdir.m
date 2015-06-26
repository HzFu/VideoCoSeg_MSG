function [ path ] = MSG_mkdir( path )
%MSG_MKDIR Summary of this function goes here
%   Detailed explanation goes here


if (~exist(path, 'dir'))
    mkdir(path);
end

end

