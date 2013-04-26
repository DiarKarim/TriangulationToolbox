close all;
clear all;

disp('== Unit-test of Auxiliary Functions for Triangulation Toolbox ==');

% The given landmark map and true pose
map =                                          ...
[                                              ...
    % x,  y,  z, r_x, r_y, r_z                 ...
      0,  0,  0,   0,  0,  0;                  ...
      5,  0,  5,   0,  0,  tran_deg2rad( +90); ...
      5,  5,  0,   0,  0,  tran_deg2rad(-180); ...
      0,  5,  5,   0,  0,  tran_deg2rad( -90); ...
];
pose = [5, 5, 5, 0, 0, pi / 2];

% test_is_equal
disp('==== test_is_true ====');
test_is_true(82 < 84);
test_is_true([10, 18] == [10, 18]);
test_is_true(~isequal([3, 2, 9], [1, 0, 1, 8]));

% test_is_near
disp('==== test_is_near ====');
test_is_near(82, 84, 5);
test_is_near(4.17, 4.17 + eps);

% error_position
disp('==== error_position====');
test_is_true(error_position([1, 2], [3, 4]) == 2 * sqrt(2));

% error_orientation
disp('==== error_orientation ====');
test_is_near(error_orientation([ 0,  0,  0], [ 0,  0, pi]), pi);
test_is_near(error_orientation([ 0,  0,  0], [ 0, pi,  0]), pi);
test_is_near(error_orientation([ 0,  0,  0], [pi,  0,  0]), 0);
test_is_near(error_orientation([ 0,  0,  0], [pi, pi,  0]), pi);
test_is_near(error_orientation([ 0,  0,  0], [ 0, pi, pi]), 0);

% trim_rad
disp('==== trim_rad ====');
test_is_true(trim_rad(pi) == -pi);
test_is_true(trim_rad(-pi) == -pi);
test_is_true(trim_rad(2 * pi) == 0);
test_is_true(trim_rad(-2 * pi) == 0);

in = (-4 * pi):(pi/100):(+4 * pi);
out = trim_rad(in);
figure('Color', [1, 1, 1]);
hold on;
    plot(in, out);
    title('trim\_rad: Correctness on [-4 * pi, +4 * pi]');
    xlabel('in [rad]');
    ylabel('out [rad]');
    axis equal;
    box on;
    grid on;
hold off;

% tran_rad2deg
disp('==== tran_rad2deg ====');
test_is_near(tran_rad2deg(pi / 6), 30);
test_is_near(tran_rad2deg(pi / 3), 60);

% tran_deg2rad
disp('==== tran_deg2rad ====');
test_is_near(tran_deg2rad(30), pi / 6);
test_is_near(tran_deg2rad(60), pi / 3);

% tran_rad2rot
disp('==== tran_rad2rot ====');
test_is_near(tran_rad2rot([0, 0, pi / 2]), [0, -1, 0; 1, 0, 0; 0, 0, 1]);
R = tran_rad2rot([pi / 6, pi / 6, pi / 6]);
test_is_near(R * R', eye(3,3));

% tran_rot2rad
disp('==== tran_rot2rad ====');
in = [pi / 6, pi / 4, pi / 3];
R = tran_rad2rot(in);
out = tran_rot2rad(R);
test_is_near(in, out);

% observe_distance
disp('==== observe_distance ====');
[obsData, obsMap] = observe_distance(map, pose);
test_is_true(obsMap == map);
test_is_near(obsData(1), norm([5, 5, 5]));
test_is_near(obsData(2), norm([5, 0, 0]));
test_is_near(obsData(3), norm([5, 0, 0]));
test_is_near(obsData(4), norm([5, 0, 0]));

test_is_true(isempty(observe_distance([], [0, 0, 0, 0, 0, 0])));                    % In case of no landmark
test_is_true(isempty(observe_distance([0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], 0))); % In case of zero visibility

% observe_distance_relative
disp('==== observe_distance_relative ====');
[obsData, obsMap] = observe_distance_relative(map, pose);
test_is_true(obsMap == map);
test_is_near(obsData(1), norm([5, 5, 5]));
test_is_near(obsData(2), norm([5, 0, 0]) - norm([5, 5, 5]));
test_is_near(obsData(3), norm([5, 0, 0]) - norm([5, 5, 5]));
test_is_near(obsData(4), norm([5, 0, 0]) - norm([5, 5, 5]));

% observe_displacement
disp('==== observe_displacement ====');
[obsData, obsMap] = observe_displacement(map, pose);
test_is_near(obsData(1,:), [-5, +5, -5]);
test_is_near(obsData(2,:), [-5,  0,  0]);
test_is_near(obsData(3,:), [ 0,  0, -5]);
test_is_near(obsData(4,:), [ 0,  5,  0]);

% observe_bearing
disp('==== observe_bearing ====');
[obsData, obsMap] = observe_bearing(map, pose);
test_is_near(obsData(1,:), [tran_deg2rad( 135), -acos(sqrt(2/3))]);
test_is_near(obsData(2,:), [tran_deg2rad(-180),       0]);
test_is_near(obsData(3,:), [tran_deg2rad(   0), -pi / 2]);
test_is_near(obsData(4,:), [tran_deg2rad(  90),       0]);

% observe_pose
disp('==== observe_pose ====');
[obsData, obsMap] = observe_pose(map, pose);
test_is_near(obsData(1,:), [-5, +5, -5,  0,  0, -pi / 2]);
test_is_near(obsData(2,:), [-5,  0,  0,  0,  0,  0     ]);
test_is_near(obsData(3,:), [ 0,  0, -5,  0,  0, +pi / 2]);
test_is_near(obsData(4,:), [ 0,  5,  0,  0,  0, -pi    ]);

% apply_noise_gauss
disp('==== apply_noise_gauss ====');
in = zeros(2000,2);
out1 = apply_noise_gauss(in, 3);
out2 = apply_noise_gauss(in, [1, 2]);
out3 = apply_noise_gauss(in, [2, 1; 1, 2]);
figure('Color', [1, 1, 1]);
hold on;
    plot(out1(:,1), out1(:,2), 'r.');
    plot(out2(:,1), out2(:,2), 'b.');
    plot(out3(:,1), out3(:,2), 'g.');
    title('apply\_noise\_gauss: Noise Distributions');
    xlabel('Data X');
    ylabel('Data Y');
    legend({'\sigma = [3, 0; 0, 3]', '\sigma = [1, 0; 0, 2]', '\sigma = [2, 1; 1, 2]'});
    grid on;
    axis equal;
    axis([-10, 10, -10, 10]);
    box on;
hold off;
