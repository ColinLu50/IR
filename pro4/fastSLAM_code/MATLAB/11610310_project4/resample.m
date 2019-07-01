% resample the set of particles.
% A particle has a probability proportional to its weight to get
% selected. A good option for such a resampling method is the so-called low
% variance sampling
function newParticles = resample(particles)
% TODO: resample particles by their important factors


numParticles = length(particles);

w = [particles.weight];

% normalize the weight
w = w / sum(w);

useNeff = false;
% useNeff = true;
flag = 0;
if useNeff
    neff = 1. / sum(w.^2);
    if neff >= 0.5*numParticles
        flag = 1;
        newParticles = particles;
        for i = 1:numParticles
            newParticles(i).weight = w(i);
        end
        return;
    end
end

newParticles = particles;

% TODO: implement the low variance re-sampling

% the cummulative sum
cs = cumsum(w);
weightSum = cs(length(cs));

% initialize the step and the current position on the roulette wheel
step = weightSum / numParticles;
position = unifrnd(0, weightSum);
idx = 1;

% walk along the wheel to select the particles
for i = 1:numParticles
    position = position + step;
    if (position > weightSum)
        position = position - weightSum;
        idx = 1;
    end
    while (position > cs(idx))
        idx = idx + 1;
    end
    newParticles(i) = particles(idx);
    newParticles(i).weight = 1/numParticles;
end



end
