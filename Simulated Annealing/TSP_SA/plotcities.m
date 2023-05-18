function f = plotcities(cityXY)
% 这个函数画城市的位置与旅行路径图
shg
pos_1 = plot(cityXY(1,:), cityXY(2,:), 'b*');
% set(pos_1, 'erasemode', 'none');
set(pos_1, 'color', 'r')
% hold on;
pos_2 = line(cityXY(1,:),cityXY(2,:), 'Marker', '*');
set(pos_2, 'color' ,'r');
x = [cityXY(1,1), cityXY(1,length(cityXY))];
y = [cityXY(2,1), cityXY(2,length(cityXY))];
x1 = 10*ceil(max(cityXY(1,:))/10);
y1 = 10*ceil(max(cityXY(2,:))/10);
if x1 == 0
    x1 = 1;
end
if y1 == 0
    y1 = 1; 
end
axis([0 x1 0 y1])
pos_3 =line(x,y);
set(pos_3, 'color', 'r');
dist = distance(cityXY);
dist_print = sprintf('%d个城市路径长：%4.6f', length(cityXY), dist);
text(x1/15, 1.05*y1, dist_print, 'fontweight', 'bold');
drawnow;
end