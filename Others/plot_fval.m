function y = plot_fval(allmins,sample_name,X)
% This function plots the fval and other parameters stored in allmins
% object

% disp(allmins)
y = arrayfun(@(x)x.Fval,allmins);

figure
plot(arrayfun(@(x)x.Fval/sqrt(size(X,1)*size(X,2)),allmins),'k*','MarkerSize',8)
xlabel('Solution number', 'FontSize',15)
ylabel('Loss Function value', 'FontSize',15)
title('Loss Function Values', 'FontSize',15)
saveas(gcf,strcat('Plots/', sample_name),'epsc');

% figure
% plot(arrayfun(@(x)x.X(7),allmins),'k*')
% xlabel('Solution number')
% ylabel('Diff. Coeff.')
% title('Diffusion Coefficient Values (1092, patch I)');

end