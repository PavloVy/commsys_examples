close all
x = linspace(-10,10);
y = erf(x);

plot(x,y)
hold on

z= qfunc(x/2*e); % Припущення про зміну бази експоненти з 2 на е, що має змінити маштаб вісі х
plot(x,-2*z+1)  % Лінійне перетворення (зміна маштабу, знаку та мінімального значення).

u = linspace(-10,10,500);
p1 = 1/pi*exp(-u.^2/1);
p2 = 1/2/pi*exp(-u.^2/2);
figure

plot(u,p1./(p1+p2))
hold on
plot(u,p2./(p1+p2))
plot([sqrt(2*log(2)),sqrt(2*log(2))],[0,1])



