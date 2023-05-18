function childCombine = PackingGA_mutate(child, prob)
random = rand();
childCombine = child;
if(random <= prob)
    len = length(child);
    index = randi([1 len],1,1);
    childCombine(1,index) = ~childCombine(1,index);
end
end