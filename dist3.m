function r = dist3(x, y)
% x,y: coordinate in 3d space
% r: Euclidean distance between x and y

r = sqrt((y(1)-x(1))^2 + (y(2)-x(2))^2 + (y(3)-x(3))^2);
end

