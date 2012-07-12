close all;
clear all;

disp('== Test of Algorithms for Triangulation Toolbox ==');

% The given landmark map and true pose
trueMap =                                      ...
[                                              ...
    % x,  y,  z, r_x, r_y, r_z                 ...
      0,  0,  0,   0,  0,  0;                  ...
      5,  0,  0,   0,  0,  tran_deg2rad( +90); ...
      5,  5,  0,   0,  0,  tran_deg2rad(-180); ...
      0,  5,  0,   0,  0,  tran_deg2rad( -90)  ...
];
truePose = [3, 2, 0, 0, 0, pi / 9];

% localize2d_sayed05
disp('==== localize2d_sayed05 ====');
[obsData, obsMap] = observe_distance(trueMap, truePose);
[pose, valid] = localize2d_sayed05(obsData, obsMap);
test_is_true(valid == [1, 1, 0, 0, 0, 0]);
test_is_near(pose(valid == true), truePose(valid == true));

% localize2d_se05
disp('==== localize2d_se05 ====');
[obsData, obsMap] = observe_displacement(trueMap, truePose);
[pose, valid] = localize2d_se05(obsData, obsMap);
test_is_true(valid == [1, 1, 0, 0, 0, 1]);
test_is_near(pose(valid == true), truePose(valid == true));

% localize2d_shimshoni02_algebraic
disp('==== localize2d_shimshoni02_algebraic ====');
[obsData, obsMap] = observe_bearing(trueMap, truePose);
[pose, valid] = localize2d_shimshoni02_algebraic(obsData, obsMap);
test_is_true(valid == [1, 1, 0, 0, 0, 1]);
test_is_near(pose(valid == true), truePose(valid == true));

% localize2d_shimshoni02_improved
disp('==== localize2d_shimshoni02_improved ====');
[obsData, obsMap] = observe_bearing(trueMap, truePose);
[pose, valid] = localize2d_shimshoni02_improved(obsData, obsMap);
test_is_true(valid == [1, 1, 0, 0, 0, 1]);
test_is_near(pose(valid == true), truePose(valid == true));
