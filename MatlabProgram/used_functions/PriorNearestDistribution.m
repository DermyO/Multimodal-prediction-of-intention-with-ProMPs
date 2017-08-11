function [type, dist] = PriorNearestDistribution(test, promp)
    for i=1:length(promp)
        d(i) = kl_div(test, promp{i}.facePose);
    end

    [dist, type ] = min(d);
    %display(['Min distance = ', num2str(type), ' (', promp{type}.traj.label, ') with ', num2str(dist)]);

end