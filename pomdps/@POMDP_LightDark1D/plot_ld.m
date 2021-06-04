function [h] = plot_ld(obj, t_min, t_max, x_min, x_max)

x = linspace(x_min, x_max, 20)';
t = linspace(t_min, t_max, 20)';
[T,X] = meshgrid(t,x);
V = abs(X - obj.ll_) + 1e-6;

hold on;
[~,h] = contourf(T,X,V,100);
set(h,'LineColor','none')
tempcolormap = colormap('gray');
colormap(flipud(tempcolormap));
colorbar

end

