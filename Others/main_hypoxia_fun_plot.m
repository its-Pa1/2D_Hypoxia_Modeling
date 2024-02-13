clear all;
clc
close all;

% figure 6
x = 0:0.01:1;

xl = 0.1;
xh = 0.8;

gamma = 1;
k1 = 12;
k2 = 8;
k3 = 0.1;

y_lin = (1-x);%exp(-3*x);
y_exp = gamma.*(exp(-3*x));
y_gen = gamma*(k1./(k1  + exp(k2*(x - k3))));


y = y_lin;

mask = x<=xl | x>=xh;
y(mask) = 0;



figure
plot(x,y,'LineWidth',2);
xlabel('$O_2$','interpreter','latex', FontSize=16);
ylabel('CA9',FontSize=16);
set(gca, FontSize=14)
saveas(gca, 'Plots/hypo_0','epsc')
saveas(gca, 'Plots/hypo_0.png')

y = y_exp;

mask = x<=xl | x>=xh;
y(mask) = 0;

figure
plot(x,y,'LineWidth',2);
xlabel('$O_2$','interpreter','latex', FontSize=16);
ylabel('CA9',FontSize=16);
set(gca, FontSize=14)
saveas(gca, 'Plots/hypo_1','epsc')

% 
y = y_gen;

mask = x<=xl | x>=xh;
y(mask) = 0;
figure
plot(x,y,'LineWidth',2);
xlabel('$O_2$','interpreter','latex', FontSize=16);
ylabel('CA9',FontSize=16);
set(gca, FontSize=14)
saveas(gca, 'Plots/hypo_2','epsc')

