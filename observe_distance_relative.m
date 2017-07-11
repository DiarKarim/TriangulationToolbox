function [obsData, obsMap] = observe_distance_relative(map, pose, visibleRate)
%OBSERVE_DISTANCE_RELATIVE  Measure distance of landmarks relative to the first observation.
%
%   [OBS_DATA, OBS_MAP] = CALCULATE_DISTANCE_RELATIVE(MAP, POSE, VISIBLE_RATE)
%       (matrix) MAP         : A landmark map (Nx6 matrix)
%       (matrix) POSE        : Pose of the target object (1x6 matrix)
%       (scalar) VISIBLE_RATE: Visible probability of landmarks (default: 1)
%       (matrix) OBS_DATA    : The relative distance from POSE to landmarks (Mx1 matrix)
%       (matrix) OBS_MAP     : The landmark map of measured landmarks (Mx6 matrix)
%
%   Note: Pose of an object, POSE, is represented by 1x6 vector whose first three
%       columns represent position of the object, (x, y, z), and last three
%       columns represent orientation of the object, (r_x, r_y, r_z) [rad].
%
%   Note: A landmark map, MAP, is Nx6 matrix which contains position and
%       orientation of landmarks in the world coordinate. Its first three columns
%       represents position of landmarks, (x, y, z). Its last three columns represent
%       orientation of landmarks, (r_x, r_y, r_z) [rad].
%
%   Note: The number of output data, M, will be approximately VISIBLE_RATE * N.
%       If there is no visible landmark, OBS_DATA and OBS_MAP will be an empty matrix.
%       Please use the command, ISEMPTY, to identify an empty matrix.
%
%   Example:
%       map  = [ 0, 0, 5, 0, 0, 0; ...
%                5, 0, 5, 0, 0, 0; ...
%                5, 5, 5, 0, 0, 0; ...
%                0, 5, 5, 0, 0, 0 ];
%       pose = [ 3, 2, 9, 0, 0, pi / 2 ];
%       [obsData, obsMap] = observe_distance_relative(map, pose)
%
%   See also observe_distance, observe_bearing, observe_displacement, observe_pose.

if nargin < 3
    visibleRate = 1;
end

[obsData, obsMap] = observe_distance(map, pose, visibleRate);
if ~isempty(obsData)
    obsData(2:end) = obsData(2:end) - obsData(1);
end
