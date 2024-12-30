function score = RanksvmScore(SegmentA, SegmentB, RelativeImp)
%RANKSVMSCORE Scoring by RankSVM based on two Gestalt principles (proximity and continuity)

    % Compute proximity
    endpointsA = [SegmentA(1, :); SegmentA(end, :)];
    endpointsB = [SegmentB(1, :); SegmentB(end, :)];

    % Calculate pairwise distances
    distances = sqrt(sum((endpointsA(1,:) - endpointsB).^2, 2));
    distances = [distances; sqrt(sum((endpointsA(2,:) - endpointsB).^2, 2))];

    [mindis, ind] = min(distances);
    Pro = mindis;

    % Compute continuity
    Con = ComputeContinuity(SegmentA, SegmentB, ind) / 2;

    % Weighted score calculation
    score = [Pro, Con] * abs(RelativeImp');
end

function distance = ComputeDistance(pointA, pointB)
    % Compute Euclidean distance between two points (kept for potential reuse)
    distance = sqrt(sum((pointA - pointB).^2));
end

function Con = ComputeContinuity(SegmentA, SegmentB, ind)
    % Compute directional vectors for continuity
    vecA = ComputeDirectionalVectors(SegmentA);
    vecB = ComputeDirectionalVectors(SegmentB);

    % Select vectors based on minimum distance index
    switch ind
        case 1, Con = subspace(vecA.head', vecB.head');
        case 2, Con = subspace(vecA.head', vecB.tail');
        case 3, Con = subspace(vecA.tail', vecB.head');
        otherwise, Con = subspace(vecA.tail', vecB.tail');
    end
end

function vectors = ComputeDirectionalVectors(Segment)
    % Compute head and tail directional vectors
    if size(Segment, 1) > 10
        headVec = Segment(5, :) - Segment(1, :);
        tailVec = Segment(end-5, :) - Segment(end, :);
    else
        headVec = Segment(end, :) - Segment(1, :);
        tailVec = -headVec;
    end
    vectors.head = headVec;
    vectors.tail = tailVec;
end
