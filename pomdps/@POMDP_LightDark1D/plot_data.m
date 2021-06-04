function [] = plot_data(obj, data)

%dimensions of environment
x_min=inf;
x_max=-inf;
for i=1:length(data)
    for j=1:length(data(i).b.w)
        if(data(i).b.s(j) < x_min)
            x_min = data(i).b.s(j);
        end
        if(data(i).b.s(j) > x_max)
            x_max = data(i).b.s(j);
        end
    end
end

t_min=0;
t_max=length(data)+1;

%environment
hold on;
obj.plot_ld(t_min,...
            t_max,...
            x_min,...
            x_max);

%particles
for i=1:length(data)
    b = data(i).b;
    hold on;
    obj.plot_particles(b, i-1);
end

%states
for i=1:length(data)
    t(i) = i-1;
    s(i) = data(i).s;
end
hold on;
plot(t,s,'r-','linewidth',2);

axis image;
xlabel('Time');
ylabel('State');

end

