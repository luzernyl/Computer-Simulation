clear all;

n = 200;  % Size of matrix 
population = 0.8;  % population density
T = 1000; % max time step
T1 = 10;   % average duration of infected state
T2 = 180; % average duration of recovered state
delta = 1;  % variance of the duration of recovered state
p_recover = 0.5; % Probability of I -> R
p_suscept = 0.1; % Probability of R -> S
isMove = 1;  % With movement or not

if(isMove == 1)
    txtmove = 'Yes';
else
    txtmove = 'No';
end

mat = -1*ones(n,n);
Itime = zeros(n,n);
Rtime = zeros(n,n);
ever_I = zeros(n,n);

None = -1;
S = 0;
I = 1;
R = 2;

%rows = randi([1 n], population*n*2, 1);
%cols = randi([1 n], population*n*2, 1);
ind = randi([1 n], population*n*2,2);
mat(ind(:,1),ind(:,2)) = 0;
mat(ceil(n/2), ceil(n/2)) = 1;
Itime(ceil(n/2), ceil(n/2)) = 1;  % duration of infection
ever_I(ceil(n/2), ceil(n/2)) = 1; % ever infected or not 
temp = mat;

n_suscept = zeros(0,T);
n_infected = zeros(0,T);
n_recovered = zeros(0,T);

[temp,tempItime,tempRtime] = move(mat,Itime,Rtime);  
mat = temp;
Itime = tempItime;
Rtime = tempRtime;
[temp,tempItime,tempRtime] = move(mat,Itime,Rtime);  
mat = temp;
Itime = tempItime;
Rtime = tempRtime;

[temp,tempItime,tempRtime] = move(mat,Itime,Rtime);  
mat = temp;
Itime = tempItime;
Rtime = tempRtime;
[temp,tempItime,tempRtime] = move(mat,Itime,Rtime);  
mat = temp;
Itime = tempItime;
Rtime = tempRtime;

figure(1);
imh = image('cdata',cat(3, mat==I, mat==R, mat==S));
axis image;

for k = 1 : T
    for i = 1 : n
        for j = 1 : n            
            % count for number of infected neighbours
            IN = 0; 
            
            if(mat(i,j) == 0)
                East = j + 1;
                West = j - 1;
                North = i - 1;
                South = i + 1;
                if(East == n + 1) 
                    East = 1; 
                end
                if(West == 0) 
                    West = n; 
                end
                if(North == 0) 
                    North = n; 
                end
                if(South == n + 1) 
                    South = 1; 
                end
                
                % Number of infected neighbours
                if(mat(i,East) == 1 || mat(i,West) == 1 ...
                        || mat(North,j) == 1 || mat(South,j) == 1 ...
                        || mat(North,East) == 1 || mat(South,East) == 1 ...
                        || mat(North,West) == 1 || mat(South,West) == 1)
                    IN = IN + 1;
                end
            end
            
            a = -1.5;
            b = 1.5;
            
            % Probability of S -> I (logistic function)
            p_infect = 1 / (1 + exp(-(a+b*IN)));
            g = rand;
            if(g < p_infect && mat(i,j) == 0 && IN > 0)
                temp(i,j) = 1;
            end
            
            if(mat(i,j) == 1)
                Itime(i,j) = Itime(i,j) + 1;
                if(Itime(i,j) >= T1 && rand <= p_recover)
                    temp(i,j) = 2;
                    Itime(i,j) = 0;
                end
            end
            if(mat(i,j) == 2)
                Rtime(i,j) = Rtime(i,j) + 1;
                if(Rtime(i,j) >= T2 && rand <= p_suscept)
                    temp(i,j) = 0;
                    Rtime(i,j) = 0;
                end
            end
        end
    end
    mat = temp;
    countS = length(find(mat==S));
    countI = length(find(mat==I));
    countR = length(find(mat==R));
    
    figure(1);
    set(imh, 'cdata', cat(3, mat==I, mat==R, mat==S));
    str1 = ['Susceptible (Blue):', num2str(countS), ...
        ' , Infected (Red):', num2str(countI), ...
        ' , Recovered (Green):', num2str(countR)];
    str2 = ['Movement :', txtmove];
    str3 = ['Time : ', num2str(k), 'times'];
    title({str1, str2, str3});
    drawnow;
    pause(0.1);
    
    if(isMove == 1)
        [temp,tempItime,tempRtime] = move(mat,Itime,Rtime);
        mat = temp;
        Itime = tempItime;
        Rtime = tempRtime;
        countS = length(find(mat==S));
        countI = length(find(mat==I));
        countR = length(find(mat==R));
        set(imh, 'cdata', cat(3, mat==I, mat==R, mat==S));
        str1 = ['Susceptible (Blue):', num2str(countS), ...
            ' , Infected (Red):', num2str(countI), ...
            ' , Recovered (Green):', num2str(countR)];
        str2 = ['Movement :', txtmove];
        str3 = ['Time : ', num2str(k), 'times'];
        title({str1, str2, str3});
        drawnow;
        pause(0.1);
    end
    
    n_suscept(k) = countS;
    n_infected(k) = countI;
    n_recovered(k) = countR;
    
    if(countI == 0)
        break;
    end
end
figure(2);
plot(1:k, n_suscept);
text(k, n_suscept(k),["Mean of S = ",mean(n_suscept)]);
xlabel("Timesteps (days)");
ylabel("Number");
title("SIR Plot, Movement :" + txtmove);
hold on
plot(1:k, n_infected);
text(k, n_infected(k),["Mean of I = ",mean(n_infected)]);
plot(1:k, n_recovered);
text(k, n_recovered(k),["Mean of R = ",mean(n_recovered)]);
hold off
legend('S','I','R');

function [mat1,mat2,mat3] = move(mat1, mat2, mat3)
n = size(mat1);
n = n(1);
temp = mat1;
for i = 1 : n
    for j = 1 : n
        if(mat1(i,j) ~= -1)
            East = j + 1;
            West = j - 1;
            North = i - 1;
            South = i + 1;
            if(East == n + 1)
                East = 1;
            end
            if(West == 0)
                West = n;
            end
            if(North == 0)
                North = n;
            end
            if(South == n + 1)
                South = 1;
            end
            
            neighbour = isNeighbours(i,j,mat1,[East, West, North, South]);
            move = randi([1 length(neighbour)],1,1);
            if(neighbour(move) == "left")
                x = mat1(i,West);
                mat1(i,West) = mat1(i,j);
                mat1(i,j) = x;
                y = mat2(i,West);
                mat2(i,West) = mat2(i,j);
                mat2(i,j) = y;
                z = mat3(i,West);
                mat3(i,West) = mat3(i,j);
                mat3(i,j) = z;
            elseif(neighbour(move) == "right")
                x = mat1(i,East);
                mat1(i,East) = mat1(i,j);
                mat1(i,j) = x;
                y = mat2(i,East);
                mat2(i,East) = mat2(i,j);
                mat2(i,j) = y;
                z = mat3(i,East);
                mat3(i,East) = mat3(i,j);
                mat3(i,j) = z;
            elseif(neighbour(move) == "up")
                x = mat1(North,j);
                mat1(North,j) = mat1(i,j);
                mat1(i,j) = x;
                y = mat2(North,j);
                mat2(North,j) = mat2(i,j);
                mat2(i,j) = y;
                z = mat3(North,j);
                mat3(North,j) = mat3(i,j);
                mat3(i,j) = z;
            elseif(neighbour(move) == "down")
                x = mat1(South,j);
                mat1(South,j) = mat1(i,j);
                mat1(i,j) = x;
                y = mat2(South,j);
                mat2(South,j) = mat2(i,j);
                mat2(i,j) = y;
                z = mat3(South,j);
                mat3(South,j) = mat3(i,j);
                mat3(i,j) = z;
            end
            %end
        end
    end
end
end

function neighbour = isNeighbours(i,j,mat,ewns)
E = ewns(1);
W = ewns(2);
N = ewns(3);
S = ewns(4);
neighbour = [];
if(mat(i,E) ~= -1 && mat(i,W) ~= -1 && mat(N,j) ~= -1 && mat(S,j) ~= -1)
    neighbour = ["stay"];
elseif(mat(i,E) == -1 && mat(i,W) ~= -1 && mat(N,j) ~= -1 && mat(S,j) ~= -1)
    neighbour = ["right","stay"];
elseif(mat(i,E) ~= -1 && mat(i,W) == -1 && mat(N,j) ~= -1 && mat(S,j) ~= -1)
    neighbour = ["left","stay"];
elseif(mat(i,E) ~= -1 && mat(i,W) ~= -1 && mat(N,j) == -1 && mat(S,j) ~= -1)
    neighbour = ["up","stay"];
elseif(mat(i,E) ~= -1 && mat(i,W) ~= -1 && mat(N,j) ~= -1 && mat(S,j) == -1)
    neighbour = ["down","stay"];
elseif(mat(i,E) == -1 && mat(i,W) == -1 && mat(N,j) ~= -1 && mat(S,j) ~= -1)
    neighbour = ["left","right","stay"];
elseif(mat(i,E) ~= -1 && mat(i,W) == -1 && mat(N,j) ~= -1 && mat(S,j) == -1)
    neighbour = ["left","down","stay"];
elseif(mat(i,E) ~= -1 && mat(i,W) == -1 && mat(N,j) == -1 && mat(S,j) ~= -1)
    neighbour = ["left","up","stay"];
elseif(mat(i,E) == -1 && mat(i,W) ~= -1 && mat(N,j) == -1 && mat(S,j) ~= -1)
    neighbour = ["right","up","stay"];
elseif(mat(i,E) == -1 && mat(i,W) ~= -1 && mat(N,j) ~= -1 && mat(S,j) == -1)
    neighbour = ["right","down","stay"];
elseif(mat(i,E) ~= -1 && mat(i,W) ~= -1 && mat(N,j) == -1 && mat(S,j) == -1)
    neighbour = ["up","down","stay"];
elseif(mat(i,E) ~= -1 && mat(i,W) == -1 && mat(N,j) == -1 && mat(S,j) == -1)
    neighbour = ["left","up","down","stay"];
elseif(mat(i,E) == -1 && mat(i,W) ~= -1 && mat(N,j) == -1 && mat(S,j) == -1)
    neighbour = ["right","up","down","stay"];
elseif(mat(i,E) == -1 && mat(i,W) == -1 && mat(N,j) ~= -1 && mat(S,j) == -1)
    neighbour = ["left","right","down","stay"];
elseif(mat(i,E) == -1 && mat(i,W) == -1 && mat(N,j) == -1 && mat(S,j) ~= -1)
    neighbour = ["left","right","up","stay"];
else
    neighbour = ["left","right","up","down","stay"];
end
end