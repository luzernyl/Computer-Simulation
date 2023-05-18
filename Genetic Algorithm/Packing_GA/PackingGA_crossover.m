function childCombine = PackingGA_crossover(parent1Combine, ...
    parent2Combine, prob)
random = rand();
if(random <= prob)
    len = length(parent1Combine);
    mid = floor(parent1Combine/2);
    childCombine = zeros(1,len);
    childCombine(1,1:mid) = parent1Combine(1,1:mid);
    childCombine(1,mid+1:len) = parent2Combine(1,mid+1:len);
else
    childCombine = parent1Combine;
end
end